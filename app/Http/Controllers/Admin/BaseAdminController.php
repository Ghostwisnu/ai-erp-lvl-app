<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class BaseAdminController extends Controller
{
    protected function renderAdminPage(string $component, array $props = [])
    {
        $user = Auth::user();
        $authData = null;
        $filteredMenus = [];

        if ($user) {
            $roles = $user->roles->pluck('name')->toArray();

            // Ambil permission user dari database (via relasi Role)
            $permissions = DB::table('permissions')
                ->join('role_has_permissions', 'permissions.id', '=', 'role_has_permissions.permission_id')
                ->join('model_has_roles', 'role_has_permissions.role_id', '=', 'model_has_roles.role_id')
                ->where('model_has_roles.model_id', $user->id)
                ->where('model_has_roles.model_type', get_class($user))
                ->pluck('permissions.name')
                ->unique()
                ->values()
                ->toArray();

            $photoUrl = null;
            if ($user->employee && $user->employee->photo_path) {
                $photoUrl = asset('storage/' . $user->employee->photo_path);
            }

            $authData = [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'roles' => $roles,
                    'permissions' => $permissions,
                    'photo_url' => $photoUrl,
                ]
            ];

            // ==========================================
            // LOGIKA FILTER MENU (BERLAKU UNTUK SEMUA)
            // ==========================================
            $isSuperAdmin = in_array('super-admin', $roles);

            $menus = Menu::with('subMenus')->orderBy('order')->get();

            $filteredMenus = $menus->map(function ($menu) use ($permissions, $isSuperAdmin) {
                // 1. Filter Submenu
                $menu->setRelation('subMenus', $menu->subMenus->filter(function ($sub) use ($permissions, $isSuperAdmin) {
                    if ($isSuperAdmin) return true; // Super admin lihat semua
                    if (empty($sub->permission_name)) return true; // Submenu tanpa permission
                    return in_array($sub->permission_name, $permissions); // Cek permission
                })->values());

                return $menu;
            })->filter(function ($menu) use ($permissions, $isSuperAdmin) {
                // 2. Filter Menu Induk
                if (!$isSuperAdmin && !empty($menu->permission_name)) {
                    if (!in_array($menu->permission_name, $permissions)) {
                        return false; // Sembunyikan jika tidak punya permission
                    }
                }

                // 3. Sembunyikan menu induk jika kosong (tidak ada submenu & tidak ada route)
                if ($menu->subMenus->isEmpty() && empty($menu->route)) {
                    return false;
                }

                return true;
            })->values();
        }

        $mergedProps = array_merge($props, [
            'auth' => $authData,
            'menus' => $filteredMenus,
        ]);

        return Inertia::render($component, $mergedProps);
    }
}
