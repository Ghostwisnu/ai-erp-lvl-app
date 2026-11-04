<?php

namespace App\Http\Controllers\Admin;

use App\Models\Menu;
use App\Models\SubMenu;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Symfony\Component\HttpFoundation\Response;

class SubMenuController extends BaseAdminController
{
    /** @return Responsable|Response */
    public function index()
    {
        return $this->renderAdminPage('Admin/SubMenus/Index', [
            'subMenus' => SubMenu::with('menu')->orderBy('menu_id')->orderBy('order')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function create()
    {
        return $this->renderAdminPage('Admin/SubMenus/Create', [
            'menus' => Menu::orderBy('order')->get(),
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'menu_id' => 'required|exists:menus,id',
            'name' => 'required|string|max:255',
            'route' => 'nullable|string|max:255',
            'order' => 'required|integer|min:0',
            'permission_name' => 'nullable|string|exists:permissions,name',
        ]);

        SubMenu::create($validated);

        return redirect()->route('admin.submenus.index')
            ->with('success', 'Sub Menu berhasil dibuat.');
    }

    /** @return Responsable|Response */
    public function show(SubMenu $submenu)
    {
        return $this->renderAdminPage('Admin/SubMenus/Show', [
            'submenu' => $submenu->load('menu'),
        ]);
    }

    /** @return Responsable|Response */
    public function edit(SubMenu $submenu)
    {
        return $this->renderAdminPage('Admin/SubMenus/Edit', [
            'submenu' => $submenu,
            'menus' => Menu::orderBy('order')->get(),
            'permissions' => Permission::orderBy('name')->get(),
        ]);
    }

    /** @return Responsable|Response */
    public function update(Request $request, SubMenu $submenu)
    {
        $validated = $request->validate([
            'menu_id' => 'required|exists:menus,id',
            'name' => 'required|string|max:255',
            'route' => 'nullable|string|max:255',
            'order' => 'required|integer|min:0',
            'permission_name' => 'nullable|string|exists:permissions,name',
        ]);

        $submenu->update($validated);

        return redirect()->route('admin.submenus.index')
            ->with('success', 'Sub Menu berhasil diupdate.');
    }

    /** @return Responsable|Response */
    public function destroy(SubMenu $submenu)
    {
        $submenu->delete();

        return redirect()->route('admin.submenus.index')
            ->with('success', 'Sub Menu berhasil dihapus.');
    }
}
