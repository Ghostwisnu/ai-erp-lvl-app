<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class LogAdmsRequest
{
    public function handle(Request $request, Closure $next)
    {
        Log::info('ADMS request', [
            'method' => $request->method(),
            'url' => $request->fullUrl(),
            'ip' => $request->ip(),
            'body' => mb_substr($request->getContent(), 0, 2000),
        ]);

        return $next($request);
    }
}
