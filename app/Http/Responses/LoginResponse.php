<?php

namespace App\Http\Responses;

use Illuminate\Http\JsonResponse;
use Laravel\Fortify\Contracts\LoginResponse as LoginResponseContract;
use Symfony\Component\HttpFoundation\Response;

class LoginResponse implements LoginResponseContract
{
    public function toResponse($request): Response
    {
        // Untuk request Inertia (XHR), kembalikan response 200 agar React bisa redirect.
        // Inertia akan otomatis mengikuti header redirect dari response ini.
        if ($request->wantsJson()) {
            return new JsonResponse(['two_factor' => false], 200);
        }

        // Untuk request biasa, arahkan langsung ke halaman admin.
        // Kita abaikan logika tim (current_team) agar tidak memicu 403.
        return redirect()->intended('/settings/profile');
    }
}
