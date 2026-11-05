<?php

namespace App\Http\Controllers;

use App\Services\FingerPunchService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FingerPushController extends Controller
{
    public function store(Request $request, FingerPunchService $service): JsonResponse
    {
        $token = (string) config('services.finger.token');
        if ($token === '' || ! hash_equals($token, (string) $request->bearerToken())) {
            abort(401, 'Unauthorized');
        }

        $data = $request->validate([
            'punches' => ['required', 'array', 'max:2000'],
            'punches.*.pin' => ['required', 'string', 'max:50'],
            'punches.*.scan_time' => ['required', 'date'],
        ]);

        $saved = 0;
        foreach ($data['punches'] as $punch) {
            if ($service->store($punch['pin'], Carbon::parse($punch['scan_time']))) {
                $saved++;
            }
        }

        return response()->json(['received' => count($data['punches']), 'saved' => $saved]);
    }
}
