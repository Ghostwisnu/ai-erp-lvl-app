<?php

namespace App\Http\Controllers\Admin;

use App\Models\Menu;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Symfony\Component\HttpFoundation\Response;

class MenuController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/Menus/Index', [
            'menus' => Menu::withCount('subMenus')->orderBy('order')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function create()
    {
        return $this->renderAdminPage('Admin/Menus/Create', [
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'route' => 'nullable|string|max:255',
            'icon' => 'nullable|string|max:255',
            'order' => 'required|integer|min:0',
            'permission_name' => 'nullable|string|exists:permissions,name',
        ]);

        Menu::create($validated);

        return redirect()->route('admin.menus.index')
            ->with('success', 'Menu berhasil dibuat.');
    }

    /** @return Responsable|Response */
    public function show(Menu $menu)
    {
        return $this->renderAdminPage('Admin/Menus/Show', [
            'menu' => $menu->load('subMenus'),
        ]);
    }

    /** @return Responsable|Response */
    public function edit(Menu $menu)
    {
        return $this->renderAdminPage('Admin/Menus/Edit', [
            'menu' => $menu,
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function update(Request $request, Menu $menu)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'route' => 'nullable|string|max:255',
            'icon' => 'nullable|string|max:255',
            'order' => 'required|integer|min:0',
            'permission_name' => 'nullable|string|exists:permissions,name',
        ]);

        $menu->update($validated);

        return redirect()->route('admin.menus.index')
            ->with('success', 'Menu berhasil diupdate.');
    }

    /** @return Responsable|Response */
    public function destroy(Menu $menu)
    {
        $menu->delete();

        return redirect()->route('admin.menus.index')
            ->with('success', 'Menu berhasil dihapus beserta sub menu-nya.');
    }
}
