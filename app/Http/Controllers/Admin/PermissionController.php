<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Symfony\Component\HttpFoundation\Response;

class PermissionController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/Permissions/Index', [
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function create()
    {
        return $this->renderAdminPage('Admin/Permissions/Create');
    }

    /** @return Responsable|Response */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:permissions,name',
        ]);

        Permission::create(['name' => $request->name]);

        return redirect()->route('admin.permissions.index')
            ->with('success', 'Permission berhasil dibuat.');
    }

    /** @return Responsable|Response */
    public function show(Permission $permission)
    {
        return $this->renderAdminPage('Admin/Permissions/Show', [
            'permission' => $permission->load('roles'),
        ]);
    }

    /** @return Responsable|Response */
    public function edit(Permission $permission)
    {
        return $this->renderAdminPage('Admin/Permissions/Edit', [
            'permission' => $permission,
        ]);
    }

    /** @return Responsable|Response */
    public function update(Request $request, Permission $permission)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:permissions,name,'.$permission->id,
        ]);

        $permission->update(['name' => $request->name]);

        return redirect()->route('admin.permissions.index')
            ->with('success', 'Permission berhasil diupdate.');
    }

    /** @return Responsable|Response */
    public function destroy(Permission $permission)
    {
        if ($permission->roles()->count() > 0) {
            return back()->with('error', 'Permission masih dipakai oleh role. Lepaskan terlebih dahulu.');
        }

        $permission->delete();

        return redirect()->route('admin.permissions.index')
            ->with('success', 'Permission berhasil dihapus.');
    }
}
