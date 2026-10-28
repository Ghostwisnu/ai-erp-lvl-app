import { Link, usePage } from '@inertiajs/react';
import { ChevronRight } from 'lucide-react';
import AppLogo from '@/components/app-logo';
import { NavUser } from '@/components/nav-user';
import {
    Collapsible,
    CollapsibleContent,
    CollapsibleTrigger,
} from '@/components/ui/collapsible';
import {
    Sidebar, SidebarContent, SidebarFooter, SidebarGroup, SidebarGroupLabel,
    SidebarHeader, SidebarMenu, SidebarMenuButton, SidebarMenuItem,
    SidebarMenuSub, SidebarMenuSubButton, SidebarMenuSubItem,
} from '@/components/ui/sidebar';

export function AppSidebar() {
    const page = usePage<any>();
    const auth = page.props.auth;
    const menus = page.props.menus || [];

    return (
        <Sidebar collapsible="icon" variant="inset">
            <SidebarHeader>
                <SidebarMenu>
                    <SidebarMenuItem>
                        <SidebarMenuButton size="lg" asChild>
                            <Link href="/dashboard" prefetch>
                                <AppLogo />
                            </Link>
                        </SidebarMenuButton>
                    </SidebarMenuItem>
                </SidebarMenu>
            </SidebarHeader>

            <SidebarContent>
                <SidebarGroup>
                    <SidebarGroupLabel>Aplikasi</SidebarGroupLabel>
                    <SidebarMenu>
                        {menus.map((menu: any) => {
                            // Jika menu tidak punya sub_menus, render sebagai link biasa
                            if (!menu.sub_menus || menu.sub_menus.length === 0) {
                                return (
                                    <SidebarMenuItem key={menu.id}>
                                        <SidebarMenuButton asChild>
                                            <Link href={menu.route || '#'}>
                                                <span>{menu.name}</span>
                                            </Link>
                                        </SidebarMenuButton>
                                    </SidebarMenuItem>
                                );
                            }

                            // Jika menu punya sub_menus, render sebagai Collapsible (Dropdown)
                            return (
                                <Collapsible
                                    key={menu.id}
                                    asChild
                                    defaultOpen={true} // Buka otomatis (opsional)
                                    className="group/collapsible"
                                >
                                    <SidebarMenuItem>
                                        <CollapsibleTrigger asChild>
                                            <SidebarMenuButton tooltip={menu.name}>
                                                <span>{menu.name}</span>
                                                <ChevronRight className="ml-auto transition-transform duration-200 group-data-[state=open]/collapsible:rotate-90" />
                                            </SidebarMenuButton>
                                        </CollapsibleTrigger>
                                        <CollapsibleContent>
                                            <SidebarMenuSub>
                                                {menu.sub_menus.map((sub: any) => (
                                                    <SidebarMenuSubItem key={sub.id}>
                                                        <SidebarMenuSubButton asChild>
                                                            <Link href={sub.route || '#'}>
                                                                <span>{sub.name}</span>
                                                            </Link>
                                                        </SidebarMenuSubButton>
                                                    </SidebarMenuSubItem>
                                                ))}
                                            </SidebarMenuSub>
                                        </CollapsibleContent>
                                    </SidebarMenuItem>
                                </Collapsible>
                            );
                        })}
                    </SidebarMenu>
                </SidebarGroup>
            </SidebarContent>

            <SidebarFooter>
                {auth?.user && <NavUser />}
            </SidebarFooter>
        </Sidebar>
    );
}