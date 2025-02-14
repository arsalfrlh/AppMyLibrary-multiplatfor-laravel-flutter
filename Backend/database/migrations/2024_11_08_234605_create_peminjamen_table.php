<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tbl_peminjaman', function (Blueprint $table) {
            $table->increments('id_pinjam');
            $table->integer('id_user');
            $table->integer('id_buku');
            $table->date('tgl_pinjam');
            $table->date('tgl_kembali');
            $table->integer('jumlah');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tbl_peminjaman');
    }
};
