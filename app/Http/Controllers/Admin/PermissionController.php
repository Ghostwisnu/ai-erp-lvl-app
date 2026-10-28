<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;

class PermissionController extends BaseAdminController
{
    public function index()
    {
        return $this->renderAdminPage('Admin/Permissions/Index', [
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    public function create()
    {
        return $this->renderAdminPage('Admin/Permissions/Create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:permissions,name',
        ]);

        Permission::create(['name' => $request->name]);

        return redirect()->route('admin.permissions.index')
            ->with('success', 'Permission berhasil dibuat.');
    }

    public function show(Permission $permission)
    {
        return $this->renderAdminPage('Admin/Permissions/Show', [
            'permission' => $permission->load('roles'),
        ]);
    }

    public function edit(Permission $permission)
    {
        return $this->renderAdminPage('Admin/Permissions/Edit', [
            'permission' => $permission,
        ]);
    }

    public function update(Request $request, Permission $permission)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:permissions,name,' . $permission->id,
        ]);

        $permission->update(['name' => $request->name]);

        return redirect()->route('admin.permissions.index')
            ->with('success', 'Permission berhasil diupdate.');
    }

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
