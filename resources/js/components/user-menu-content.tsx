import { Link } from '@inertiajs/react';
import { LogOut, Settings } from 'lucide-react';
import {
    DropdownMenuContent,
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
} from '@/components/ui/dropdown-menu';
import { User } from '@/types';

interface Props {
    user: User;
}

export function UserMenuContent({ user }: Props) {
    if (!user) return null;

    return (
        <DropdownMenuContent className="w-56" align="end" forceMount>
            <DropdownMenuLabel className="font-normal">
                <div className="flex flex-col space-y-1">
                    <p className="text-sm font-medium leading-none">{user.name}</p>
                    <p className="text-xs leading-none text-muted-foreground">
                        {user.email}
                    </p>
                </div>
            </DropdownMenuLabel>

            <DropdownMenuSeparator />

            <DropdownMenuGroup>
                {/* Gunakan <a> biasa jika Link Inertia bermasalah dengan asChild */}
                <DropdownMenuItem asChild>
                    <a href="/settings/profile" className="w-full flex items-center cursor-pointer">
                        <Settings className="mr-2 h-4 w-4" />
                        <span>Settings</span>
                    </a>
                </DropdownMenuItem>
            </DropdownMenuGroup>

            <DropdownMenuSeparator />

            <DropdownMenuItem asChild>
                {/* Gunakan form biasa untuk logout agar tidak crash */}
                <form method="POST" action="/logout" className="w-full">
                    <input type="hidden" name="_token" value={(document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content} />
                    <button type="submit" className="w-full flex items-center cursor-pointer text-red-600 focus:text-red-600">
                        <LogOut className="mr-2 h-4 w-4" />
                        <span>Log out</span>
                    </button>
                </form>
            </DropdownMenuItem>
        </DropdownMenuContent>
    );
}