import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { useInitials } from '@/hooks/use-initials';
import { Team, User } from '@/types';

interface Props {
    // Tambahkan photo_url ke tipe data
    user: User & { photo_url?: string | null };
    team?: Team | null;
    showEmail?: boolean;
}

export function UserInfo({ user, team, showEmail = false }: Props) {
    const getInitials = useInitials();

    if (!user) return null;

    return (
        <>
            <Avatar className="h-8 w-8 overflow-hidden rounded-full">
                {/* HAPUS KOMENTAR DAN GUNAKAN PHOTO_URL */}
                <AvatarImage src={user.photo_url || undefined} alt={user.name} />

                {/* Fallback (Inisial) hanya akan muncul jika photo_url kosong atau error */}
                <AvatarFallback className="rounded-lg bg-neutral-200 text-black dark:bg-neutral-700 dark:text-white">
                    {getInitials(user.name)}
                </AvatarFallback>
            </Avatar>
            <div className="grid flex-1 text-left text-sm leading-tight">
                <span className="truncate font-semibold">{user.name}</span>
                {showEmail && (
                    <span className="truncate text-xs text-muted-foreground">
                        {user.email}
                    </span>
                )}
                {team && !showEmail && (
                    <span className="truncate text-xs text-muted-foreground">
                        {team.name}
                    </span>
                )}
            </div>
        </>
    );
}