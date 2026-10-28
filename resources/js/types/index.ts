import { Config } from 'tailwind-merge';
import { Auth } from './auth';
import { Team } from './teams';

export type * from './auth';
export type * from './navigation';
export type * from './teams';
export type * from './ui';
export interface SharedData {
    name: string;
    quote: { message: string; author: string };
    auth: Auth;
    ziggy: Config<string, string> & { location: string };
    currentTeam?: Team | null;
    menus: Menu[]; // <-- Tambahkan ini
    [key: string]: unknown;
}

// Tambahkan interface Menu dan SubMenu jika belum ada
export interface Menu {
    id: number;
    name: string;
    route: string | null;
    icon: string | null;
    order: number;
    permission_name: string | null;
    sub_menus: SubMenu[];
}

export interface SubMenu {
    id: number;
    menu_id: number;
    name: string;
    route: string | null;
    order: number;
    permission_name: string | null;
}