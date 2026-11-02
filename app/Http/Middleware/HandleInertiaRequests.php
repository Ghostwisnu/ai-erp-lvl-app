<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;

class HandleInertiaRequests extends Middleware
{
    protected $rootView = 'app';

    public function share(Request $request): array
    {
        $error = $request->session()->get('error');
        $success = $request->session()->get('success');
        $flashToast = is_string($error) && $error !== ''
            ? ['type' => 'error', 'message' => $error]
            : (is_string($success) && $success !== ''
                ? ['type' => 'success', 'message' => $success]
                : null);

        return array_merge(parent::share($request), [
            'flashToast' => $flashToast,
        ]);
    }
}
