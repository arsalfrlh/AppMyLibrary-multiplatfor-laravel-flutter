<?php

use App\Http\Controllers\AnggotaController;
use App\Http\Controllers\BukuController;
use App\Http\Controllers\PeminjamanController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SessionController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::middleware(['guest'])->group(function(){
    Route::get('/perpus/login',[SessionController::class,'login'])->name('login');
    Route::post('/perpus/login/proses',[SessionController::class,'login_proses']);
    Route::get('/perpus/register',[SessionController::class,'register']);
    Route::post('/perpus/register/proses',[SessionController::class,'register_proses']);
});

Route::get('/home',function(){
    return redirect('/perpus/index');
});

Route::middleware(['auth'])->group(function(){
    Route::get('/perpus/index',[SessionController::class,'index']);
    Route::get('/perpus/logout',[SessionController::class,'logout']);
    Route::get('/perpus/buku',[BukuController::class,'buku']);
    Route::get('/perpus/buku/tambah',[BukuController::class,'tambah_buku']);
    Route::post('/perpus/buku/create',[BukuController::class,'create_buku']);
    Route::get('/perpus/buku/edit/{id}',[BukuController::class,'edit_buku']);
    Route::put('/perpus/buku/update',[BukuController::class,'update_buku']);
    Route::delete('/perpus/buku/hapus/{id}',[BukuController::class,'hapus']);
    Route::get('/perpus/anggota',[AnggotaController::class,'anggota']);
    Route::get('/perpus/profile/edit',[AnggotaController::class,'profile']);
    Route::put('/perpus/profile/update',[AnggotaController::class,'update_profile']);
    Route::get('/perpus/buku/pinjam/{id}',[PeminjamanController::class,'pinjam']);
    Route::post('/perpus/pinjam/proses',[PeminjamanController::class,'pinjam_proses']);
    Route::get('/perpus/peminjaman',[PeminjamanController::class,'peminjaman']);
    Route::put('/perpus/peminjaman/pengembalian',[PeminjamanController::class,'pengembalian']);
    Route::get('/perpus/laporan',[PeminjamanController::class,'laporan']);
    Route::put('/perpus/laporan/setujui',[PeminjamanController::class,'setujui']);
    Route::put('/perpus/laporan/tolak',[PeminjamanController::class,'tolak']);
    Route::delete('/perpus/laporan/hapus',[PeminjamanController::class,'hapus']);
});