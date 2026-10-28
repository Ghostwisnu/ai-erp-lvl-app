<?php

namespace App\Http\Controllers\Settings;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

class ProfileController extends Controller
{
    public function edit(Request $request): Response
    {
        $user = $request->user();
        $roles = $user->roles->pluck('name')->toArray();
        $isSuperAdmin = in_array('super-admin', $roles);

        // 1. Ambil permission user
        $permissions = DB::table('permissions')
            ->join('role_has_permissions', 'permissions.id', '=', 'role_has_permissions.permission_id')
            ->join('model_has_roles', 'role_has_permissions.role_id', '=', 'model_has_roles.role_id')
            ->where('model_has_roles.model_id', $user->id)
            ->where('model_has_roles.model_type', get_class($user))
            ->pluck('permissions.name')
            ->unique()
            ->values()
            ->toArray();

        // 2. FILTER MENU (Sama seperti di BaseAdminController)
        $menus = Menu::with('subMenus')->orderBy('order')->get();

        $filteredMenus = $menus->map(function ($menu) use ($permissions, $isSuperAdmin) {
            $menu->setRelation('subMenus', $menu->subMenus->filter(function ($sub) use ($permissions, $isSuperAdmin) {
                if ($isSuperAdmin) return true;
                if (empty($sub->permission_name)) return true;
                return in_array($sub->permission_name, $permissions);
            })->values());
            return $menu;
        })->filter(function ($menu) use ($permissions, $isSuperAdmin) {
            if (!$isSuperAdmin && !empty($menu->permission_name) && !in_array($menu->permission_name, $permissions)) {
                return false;
            }
            if ($menu->subMenus->isEmpty() && empty($menu->route)) {
                return false;
            }
            return true;
        })->values();

        // 3. Ambil URL foto
        $photoUrl = null;
        if ($user->employee && $user->employee->photo_path) {
            $photoUrl = asset('storage/' . $user->employee->photo_path);
        }

        // 4. Kirim semua data ke React
        return Inertia::render('Settings/Profile', [
            'mustVerifyEmail' => $user instanceof \Illuminate\Contracts\Auth\MustVerifyEmail,
            'status' => session('status'),
            'menus' => $filteredMenus, // <-- Kirim menu yang SUDAH difilter
            'auth' => [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'roles' => $roles,
                    'permissions' => $permissions,
                    'photo_url' => $photoUrl, // <-- Kirim URL Foto
                ]
            ],
        ]);
    }

    public function update(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => [
                'required',
                'string',
                'lowercase',
                'email',
                'max:255',
                Rule::unique('users')->ignore($request->user()->id),
            ],
            'password' => ['nullable', 'string', 'min:8', 'confirmed'],
        ]);

        $user = $request->user();

        $user->name = $validated['name'];
        $user->email = $validated['email'];

        if ($request->filled('password')) {
            $user->password = Hash::make($validated['password']);
        }

        if ($user->isDirty('email')) {
            $user->email_verified_at = null;
        }

        $user->save();

        return redirect()->route('profile.edit')->with('status', 'profile-updated');
    }
}
