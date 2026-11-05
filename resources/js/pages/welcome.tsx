import { Head, Link, usePage } from '@inertiajs/react';
import AppLogoIcon from '@/components/app-logo-icon';
import { Button } from '@/components/ui/button';

export default function Welcome() {
    const { name, auth } = usePage<{
        name: string;
        auth?: { user?: unknown };
    }>().props;
    const loggedIn = Boolean(auth?.user);

    return (
        <>
            <Head title="Welcome" />
            <div className="flex min-h-screen flex-col items-center justify-center gap-8 bg-background px-6 text-center">
                <AppLogoIcon className="h-32 w-32 rounded-xl" />
                <div className="space-y-3">
                    <h1 className="text-3xl font-bold tracking-tight sm:text-5xl">
                        {name}
                    </h1>
                    <p className="mx-auto max-w-xl text-muted-foreground">
                        Sistem ERP terpadu untuk mengelola produksi, QC, lembur,
                        dan operasional perusahaan Anda.
                    </p>
                </div>
                <Button asChild size="lg">
                    <Link href={loggedIn ? '/dashboard' : '/login'}>
                        {loggedIn ? 'Ke Dashboard' : 'Masuk'}
                    </Link>
                </Button>
            </div>
        </>
    );
}
