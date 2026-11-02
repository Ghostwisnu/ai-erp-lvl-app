import { Head, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';
import InputError from '@/components/input-error';
import TextLink from '@/components/text-link';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Spinner } from '@/components/ui/spinner';

type Props = {
    status?: string;
    canResetPassword: boolean;
};

export default function Login({ status, canResetPassword }: Props) {
    const { data, setData, post, processing, errors, reset } = useForm({
        name: '',
        password: '',
        remember: false,
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        post('/login', {
            onFinish: () => reset('password'),
        });
    };

    return (
        <>
            <Head title="Masuk" />

            {status && (
                <div className="mb-4 text-center text-sm font-medium text-green-600">
                    {status}
                </div>
            )}

            <form onSubmit={submit} className="flex flex-col gap-6">
                <div className="grid gap-6">
                    <div className="grid gap-2">
                        <Label htmlFor="name">Nama</Label>
                        <Input
                            id="name"
                            type="text"
                            name="name"
                            required
                            autoFocus
                            tabIndex={1}
                            autoComplete="username"
                            value={data.name}
                            onChange={(e) => setData('name', e.target.value)}
                            placeholder="Nama Anda"
                        />
                        <InputError message={errors.name} />
                    </div>

                    <div className="grid gap-2">
                        <div className="flex items-center">
                            <Label htmlFor="password">Kata sandi</Label>
                            {canResetPassword && (
                                <TextLink
                                    href="/forgot-password"
                                    className="ml-auto text-sm"
                                    tabIndex={5}
                                >
                                    Lupa kata sandi?
                                </TextLink>
                            )}
                        </div>
                        <Input
                            id="password"
                            type="password"
                            name="password"
                            required
                            tabIndex={2}
                            autoComplete="current-password"
                            value={data.password}
                            onChange={(e) =>
                                setData('password', e.target.value)
                            }
                            placeholder="Kata sandi"
                        />
                        <InputError message={errors.password} />
                    </div>

                    <div className="flex items-center space-x-3">
                        <Checkbox
                            id="remember"
                            name="remember"
                            checked={data.remember}
                            onCheckedChange={(checked) =>
                                setData('remember', checked as boolean)
                            }
                            tabIndex={3}
                        />
                        <Label htmlFor="remember">Ingat saya</Label>
                    </div>

                    <Button
                        type="submit"
                        className="mt-4 w-full"
                        tabIndex={4}
                        disabled={processing}
                    >
                        {processing && <Spinner />}
                        Masuk
                    </Button>
                </div>

                <div className="text-center text-sm text-muted-foreground">
                    Belum punya akun?{' '}
                    <TextLink href="/register" tabIndex={5}>
                        Daftar
                    </TextLink>
                </div>
            </form>
        </>
    );
}

Login.layout = {
    title: 'Masuk ke akun Anda',
    description: 'Masukkan nama dan kata sandi Anda untuk masuk',
};
