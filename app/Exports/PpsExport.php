<?php

namespace App\Exports;

use App\Models\Spk;
use Carbon\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class PpsExport implements FromCollection, WithHeadings
{
    private const DEPARTMENTS = [
        'cutting' => 'PEMOTONGAN',
        'sewing' => 'PENJAHITAN',
        'lasting' => 'PEMASANGAN SOL',
        'cementing' => 'PENGELEMAN',
        'injection' => 'INJEKSI',
        'finishing' => 'PENYELESAIAN',
        'packing' => 'PENGEMASAN',
    ];

    public function __construct(private readonly ?int $brandId = null) {}

    /** @return Collection<int, array<int, int|string>> */
    public function collection(): Collection
    {
        $spks = Spk::query()
            ->with(['brand', 'batches.tracks', 'batches.dailies', 'details', 'dailies'])
            ->when($this->brandId, fn ($query) => $query->where('brand_id', $this->brandId))
            ->orderBy('brand_id')
            ->orderBy('xfd_date')
            ->get();

        $scanResults = [];
        if ($spks->isNotEmpty()) {
            $scans = DB::table('production_scans as ps')
                ->join('spk_details as d', 'd.id', '=', 'ps.spk_detail_id')
                ->whereIn('d.spk_id', $spks->pluck('id'))
                ->where('ps.department', 'finishing')
                ->select('d.spk_id', 'd.size_name', DB::raw('COUNT(*) as total_scan'))
                ->groupBy('d.spk_id', 'd.size_name')
                ->get();

            foreach ($scans as $scan) {
                $scanResults[$scan->spk_id][$scan->size_name] = (int) $scan->total_scan;
            }
        }

        $rows = [];
        $rowNumber = 1;
        foreach ($spks as $spk) {
            $productionRows = $spk->batches->isNotEmpty()
                ? $spk->batches->map(fn ($batch) => [
                    'batch' => $batch,
                    'po' => "{$spk->po_number}-{$batch->batch_code}",
                    'qty' => (int) $batch->qty,
                    'sizes' => collect($batch->sizes ?? []),
                    'tracks' => $batch->tracks,
                    'dailies' => $batch->dailies,
                ])
                : collect([[
                    'batch' => null,
                    'po' => $spk->po_number,
                    'qty' => (int) $spk->details->sum('qty'),
                    'sizes' => $spk->details,
                    'tracks' => collect(),
                    'dailies' => $spk->dailies,
                ]]);

            foreach ($productionRows as $productionRow) {
                $row = [
                    $rowNumber++,
                    $productionRow['po'],
                    $spk->brand->name ?? '-',
                    $spk->art_color,
                    $productionRow['qty'],
                ];
                $departmentRows = [];

                foreach (array_keys(self::DEPARTMENTS) as $department) {
                    $track = $productionRow['tracks']->firstWhere('department', $department);
                    $dailyEntries = $productionRow['dailies']->where('department', $department);

                    if ($department === 'finishing') {
                        $totalOutput = (int) $productionRow['sizes']
                            ->filter(fn ($size) => (int) data_get($size, 'qty') > 0)
                            ->sum(fn ($size) => $scanResults[$spk->id][data_get($size, 'size_name')] ?? 0);
                        $latestOutput = '-';
                    } else {
                        $totalOutput = (int) $dailyEntries->sum('qty');
                        $latestDaily = $dailyEntries->sortByDesc('report_date')->first();
                        $latestOutput = $latestDaily->qty ?? '-';
                    }

                    $startDate = $track?->start_date;
                    if (! $startDate && ! $productionRow['batch'] && $department === 'cutting') {
                        $startDate = $spk->start_date;
                    }

                    $departmentRows[] = [
                        $startDate ? Carbon::parse($startDate)->format('d/m/Y') : '-',
                        $latestOutput,
                        $totalOutput,
                        $productionRow['qty'] - $totalOutput,
                    ];
                }

                $rows[] = $this->appendDepartmentRows(
                    $row,
                    $departmentRows,
                    $spk->xfd_date ? Carbon::parse($spk->xfd_date)->format('d/m/Y') : '-',
                );
            }
        }

        return collect($rows);
    }

    /**
     * @param  array<int, int|string>  $row
     * @param  list<array<int, int|string>>  $departmentRows
     * @return array<int, int|string>
     */
    private function appendDepartmentRows(array $row, array $departmentRows, string $xfdDate): array
    {
        foreach ($departmentRows as $departmentRow) {
            foreach ($departmentRow as $value) {
                $row[] = $value;
            }
        }

        $row[] = $xfdDate;

        return $row;
    }

    public function headings(): array
    {
        $headings = ['NO', 'PO NO.', 'MODEL', 'WARNA', 'JUMLAH'];
        foreach (self::DEPARTMENTS as $department) {
            $headings[] = "{$department} - TGL";
            $headings[] = "{$department} - HARIAN";
            $headings[] = "{$department} - TOTAL";
            $headings[] = "{$department} - SISA";
        }

        $headings[] = 'XFD';

        return $headings;
    }
}
