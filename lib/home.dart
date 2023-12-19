import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/app_button.dart';
import 'package:flutter_application_1/components/app_text_field.dart';
import 'package:flutter_application_1/edit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> pengeluaran_list = [];

  TextEditingController keteranganController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    dynamic res = await Supabase.instance.client
        .from('expense')
        .select<List<Map<String, dynamic>>>();
    print(res);
    setState(() {
      pengeluaran_list = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Catat\nPengeluaran",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AppTextField(
                controller: keteranganController,
                label: "Keterangan",
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                controller: amountController,
                label: "Jumlah Pengeluaran",
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                onPressed: () async {
                  await Supabase.instance.client.from('expense').insert({
                    'amount': int.parse(amountController.text),
                    'description': keteranganController.text
                  });
                  fetchData();
                },
                text: "Simpan",
                color: Colors.black,
              ),
              SizedBox(
                height: 5,
              ),
              AppButton(
                text: "Reset",
                color: Colors.grey.shade200,
                textColor: Colors.black,
              ),
              Visibility(
                visible: pengeluaran_list.isEmpty,
                child: Image.asset("images/empty_image.png"),
              ),
              Column(
                children: pengeluaran_list
                    .map(
                      (pengeluaran) => Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pengeluaran['description']),
                                  Text(pengeluaran['amount'].toString()),
                                ],
                              ),
                              SizedBox(height: 20),
                              AppButton(
                                onPressed: () async {
                                  await Supabase.instance.client
                                      .from('expense')
                                      .delete()
                                      .match({'id': pengeluaran['id']});
                                  fetchData();
                                },
                                text: "Delete",
                                color: Colors.red,
                              ),
                              SizedBox(height: 10),
                              AppButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (ctx) => EditPage(
                                            id: pengeluaran['id'],
                                            description:
                                                pengeluaran['description'],
                                            amount: pengeluaran['amount']
                                                .toString(),
                                          ),
                                        ),
                                      )
                                      .then((value) => {fetchData()});
                                },
                                text: "Edit",
                                color: Color.fromARGB(255, 228, 208, 166),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
