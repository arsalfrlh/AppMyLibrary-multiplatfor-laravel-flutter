<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Peminjaman extends Model
{
    use HasFactory;
    protected $table = "peminjaman";
    protected $guarded = ['id'];

    //orm untuk menghubungkannya dengan tabel user
    public function user(){
        return $this->belongsTo(User::class,'id_user');
    }

    //orm untuk menghubungkannya dengan tabel buku
    public function buku(){
        return $this->belongsTo(Buku::class,'id_buku');
    }

    protected $fillable = ['id_user','id_buku','tgl_pinjam','tgl_kembali','jumlah','statuspinjam'];
}
