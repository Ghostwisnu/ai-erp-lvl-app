<?php

namespace App\Http\Controllers\Admin;

use App\Models\Menu;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;

class MenuController extends BaseAdminController
{
    public function index()
    {
        return $this->renderAdminPage('Admin/Menus/Index', [
            'menus' => Menu::withCount('subMenus')->orderBy('order')->get(),
        ]);
    }

    public function create()
    {
        return $this->renderAdminPage('Admin/Menus/Create', [
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'            => 'required|string|max:255',
            'route'           => 'nullable|string|max:255',
            'icon'            => 'nullable|string|max:255',
            'order'           => 'required|integer|min:0',
            'permission_name' => 'nullable|string|exists:permissions,name',
        ]);

        Menu::create($validated);

        return redirect()->route('admin.menus.index')
            ->with('success', 'Menu berhasil dibuat.');
    }

    public function show(Menu $menu)
    {
        return $this->renderAdminPage('Admin/Menus/Show', [
            'menu' => $menu->load('subMenus'),
        ]);
    }

    public function edit(Menu $menu)
    {
        return $this->renderAdminPage('Admin/Menus/Edit', [
            'menu'        => $menu,
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    public function update(Request $request, Menu $menu)
    {
        $validated = $request->validate([
            'name'            => 'required|string|max:255',
            'route'           => 'nullable|string|max:255',
            'icon'            => 'nullable|string|max:255',
            'order'           => 'required|integer|min:0',
            'permission_name' => 'nullable|string|exists:permissions,name',
        ]);

        $menu->update($validated);

        return redirect()->route('admin.menus.index')
            ->with('success', 'Menu berhasil diupdate.');
    }

    public function destroy(Menu $menu)
    {
        $menu->delete();

        return redirect()->route('admin.menus.index')
            ->with('success', 'Menu berhasil dihapus beserta sub menu-nya.');
    }
}
