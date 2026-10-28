import { Head, useForm } from '@inertiajs/react';
import { FormEvent } from 'react';
import InputError from '@/components/input-error';
import TextLink from '@/components/text-link';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Spinner } from '@/components/ui/spinner';

type Props = {
    passwordRules: string;
};

export default function Register({ passwordRules }: Props) {
    // useForm otomatis menangani state error (validasi dari Laravel)
    const { data, setData, post, processing, errors, reset } = useForm({
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
    });

    const submit = (e: FormEvent) => {
        e.preventDefault();
        // Inertia akan mengirim request ke /register
        // Jika ada error validasi (422), error akan otomatis masuk ke 'errors'
        post('/register', {
            onFinish: () => reset('password', 'password_confirmation'),
        });
    };

    return (
        <>
            <Head title="Register" />

            <form onSubmit={submit} className="flex flex-col gap-6">
                <div className="grid gap-6">
                    {/* Input Nama */}
                    <div className="grid gap-2">
                        <Label htmlFor="name">Nama Lengkap</Label>
                        <Input
                            id="name"
                            type="text"
                            required
                            autoFocus
                            tabIndex={1}
                            autoComplete="name"
                            value={data.name}
                            onChange={(e) => setData('name', e.target.value)}
                            placeholder="Nama lengkap Anda"
                            // Tambahkan border merah jika ada error
                            className={errors.name ? 'border-red-500' : ''}
                        />
                        {/* Komponen InputError otomatis menampilkan pesan jika errors.name ada */}
                        <InputError message={errors.name} className="mt-1" />
                    </div>

                    {/* Input Email */}
                    <div className="grid gap-2">
                        <Label htmlFor="email">Alamat Email</Label>
                        <Input
                            id="email"
                            type="email"
                            required
                            tabIndex={2}
                            autoComplete="email"
                            value={data.email}
                            onChange={(e) => setData('email', e.target.value)}
                            placeholder="email@example.com"
                            className={errors.email ? 'border-red-500' : ''}
                        />
                        <InputError message={errors.email} />
                    </div>

                    {/* Input Password */}
                    <div className="grid gap-2">
                        <Label htmlFor="password">Password</Label>
                        <Input
                            id="password"
                            type="password"
                            required
                            tabIndex={3}
                            autoComplete="new-password"
                            value={data.password}
                            onChange={(e) => setData('password', e.target.value)}
                            placeholder="Minimal 8 karakter"
                            className={errors.password ? 'border-red-500' : ''}
                        />
                        <InputError message={errors.password} />
                    </div>

                    {/* Input Konfirmasi Password */}
                    <div className="grid gap-2">
                        <Label htmlFor="password_confirmation">Konfirmasi Password</Label>
                        <Input
                            id="password_confirmation"
                            type="password"
                            required
                            tabIndex={4}
                            autoComplete="new-password"
                            value={data.password_confirmation}
                            onChange={(e) => setData('password_confirmation', e.target.value)}
                            placeholder="Ulangi password"
                            className={errors.password_confirmation ? 'border-red-500' : ''}
                        />
                        <InputError message={errors.password_confirmation} />
                    </div>

                    {/* Tombol Submit */}
                    <Button
                        type="submit"
                        className="mt-2 w-full"
                        tabIndex={5}
                        disabled={processing}
                    >
                        {processing && <Spinner />}
                        {processing ? 'Mendaftar...' : 'Buat Akun'}
                    </Button>
                </div>

                <div className="text-center text-sm text-muted-foreground">
                    Sudah punya akun?{' '}
                    <TextLink href="/login" tabIndex={6}>
                        Masuk di sini
                    </TextLink>
                </div>
            </form>
        </>
    );
}

Register.layout = {
    title: 'Buat Akun Baru',
    description: 'Masukkan detail Anda di bawah ini untuk membuat akun',
};