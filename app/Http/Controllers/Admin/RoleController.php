<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class RoleController extends BaseAdminController
{
    public function index()
    {
        return $this->renderAdminPage('Admin/Roles/Index', [
            'roles' => Role::with('permissions')->orderBy('name')->get(),
        ]);
    }

    public function create()
    {
        return $this->renderAdminPage('Admin/Roles/Create', [
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:255|unique:roles,name',
            'permissions'   => 'nullable|array',
            'permissions.*' => 'exists:permissions,name',
        ]);

        $role = Role::create(['name' => $validated['name']]);

        if (!empty($validated['permissions'])) {
            $role->syncPermissions($validated['permissions']);
        }

        return redirect()->route('admin.roles.index')
            ->with('success', 'Role berhasil dibuat.');
    }

    public function show(Role $role)
    {
        return $this->renderAdminPage('Admin/Roles/Show', [
            'role' => $role->load('permissions'),
        ]);
    }

    public function edit(Role $role)
    {
        return $this->renderAdminPage('Admin/Roles/Edit', [
            'role'        => $role->load('permissions'),
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    public function update(Request $request, Role $role)
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:255|unique:roles,name,' . $role->id,
            'permissions'   => 'nullable|array',
            'permissions.*' => 'exists:permissions,name',
        ]);

        if ($role->name === 'super-admin' && $validated['name'] !== 'super-admin') {
            return back()->with('error', 'Role super-admin tidak boleh di-rename.');
        }

        $role->update(['name' => $validated['name']]);

        if ($request->has('permissions')) {
            $role->syncPermissions($validated['permissions'] ?? []);
        }

        return redirect()->route('admin.roles.index')
            ->with('success', 'Role berhasil diupdate.');
    }

    public function destroy(Role $role)
    {
        if ($role->name === 'super-admin') {
            return back()->with('error', 'Role super-admin tidak boleh dihapus.');
        }

        if ($role->users()->count() > 0) {
            return back()->with('error', 'Role masih dipakai oleh user. Lepaskan role terlebih dahulu.');
        }

        $role->delete();

        return redirect()->route('admin.roles.index')
            ->with('success', 'Role berhasil dihapus.');
    }
}
