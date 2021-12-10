import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddBarangPage extends StatefulWidget {
  final String nama;
  final String idJenis;
  const AddBarangPage({this.nama, this.idJenis});

  @override
  _AddBarangPageState createState() => _AddBarangPageState();
}

class _AddBarangPageState extends State<AddBarangPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController grosirController = TextEditingController();
  TextEditingController ecerController = TextEditingController();
  TextEditingController idJenisController = TextEditingController();
  bool _validasi = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: 'id').currencySymbol;

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    grosirController.dispose();
    ecerController.dispose();
    idJenisController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Barang barang = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah ${this.widget.nama}';
    if (barang != null) {
      namaController.text = barang.nama;
      idJenisController.text = barang.id_jenis;
      ecerController.text = barang.harga_ecer;
      grosirController.text = barang.harga_grosir;
      widgetText = 'Update ${barang.nama}';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widgetText),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              // ignore: deprecated_member_use
              autovalidate: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorNama,
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorEcer,
                      controller: ecerController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga Ecer',
                        prefixText: _currency,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (string) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        ecerController.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorGrosir,
                      controller: grosirController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga Grosir',
                        prefixText: _currency,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (string) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        grosirController.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50.0,
                width: 160.0,
                child: ElevatedButton(
                  child: Text(
                    widgetText,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    if (barang != null) {
                      setState(() {
                        if (namaController.text.isEmpty ||
                            ecerController.text.isEmpty ||
                            grosirController.text.isEmpty) {
                          _validasi = true;
                        } else {
                          updateBarang(barang);
                        }
                      });
                    } else {
                      setState(() {
                        if (namaController.text.isEmpty ||
                            ecerController.text.isEmpty ||
                            grosirController.text.isEmpty) {
                          _validasi = true;
                        } else {
                          insertBarang();
                        }
                      });
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String validatorNama(String value) {
    if (value.length < 1)
      return 'Nama tidak boleh kosong !!!';
    else
      return null;
  }

  String validatorEcer(String value) {
    if (value.length < 1)
      return 'Harga Ecer tidak boleh kosong !!!';
    else
      return null;
  }

  String validatorGrosir(String value) {
    if (value.length < 1)
      return 'Harga Grosir tidak boleh kosong !!!';
    else
      return null;
  }

  insertBarang() async {
    final barang = Barang(
        id: M.ObjectId(),
        nama: namaController.text,
        id_jenis: this.widget.idJenis,
        harga_grosir: grosirController.text,
        harga_ecer: ecerController.text,
        tanggal_upload: DateTime.now().toString(),
        tanggal_update: DateTime.now().toString());
    await MongoDatabase.insertBarang(barang);
    Navigator.pop(context);

    final aTambah = SnackBar(
        content: Text('${namaController.text} Berhasil di Tambahkan !!'));
    ScaffoldMessenger.of(context).showSnackBar(aTambah);
  }

  updateBarang(Barang barang) async {
    print('updating : ${namaController.text}');
    final b = Barang(
      id: barang.id,
      nama: namaController.text,
      id_jenis: this.widget.idJenis,
      harga_ecer: ecerController.text,
      harga_grosir: grosirController.text,
    );
    await MongoDatabase.updateBarang(b);
    Navigator.pop(context);

    final aUpdate =
        SnackBar(content: Text('${barang.nama} Berhasil diupdate !!'));
    ScaffoldMessenger.of(context).showSnackBar(aUpdate);
  }
}
