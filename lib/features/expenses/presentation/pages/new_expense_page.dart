import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/category.dart';
import '../bloc/expenses_bloc.dart';
import '../widgets/category_icon.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  ExpenseCategory? _category;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_onFormChanged);
    _amountCtrl.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.select((ExpensesBloc b) => b.state.categories);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Tambah Pengeluaran Baru',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: _decoration('Nama Pengeluaran'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Harus diisi ' : null,
              ),
              const SizedBox(height: 16),
              FormField<ExpenseCategory>(
                validator: (_) => _category == null ? 'Pilih kategori' : null,
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showCategorySheet(context, categories),
                        child: InputDecorator(
                          decoration: _decoration(
                            'Kategori',
                            suffixIcon: const Icon(Icons.chevron_right,
                                color: Colors.black26),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.amber.shade100,
                                child: _category == null
                                    ? const Text('🗂️',
                                        style: TextStyle(fontSize: 16))
                                    : CategoryIcon(
                                        category: _category!, size: 48),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _category?.label ?? 'Pilih Kategori',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 6),
                          child: Text(state.errorText!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12)),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: InputDecorator(
                  decoration: _decoration(
                    'Tanggal Pengeluaran',
                    suffixIcon: const Icon(Icons.calendar_today_outlined,
                        color: Colors.black26),
                  ),
                  child: Text(_formatDate(_date)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                decoration: _decoration('Nominal').copyWith(prefixText: 'Rp. '),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Harus diisi';
                  final parsed = double.tryParse(
                      v.replaceAll('.', '').replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Nominal tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(
                              _amountCtrl.text.replaceAll(',', '.'));
                          final exp = Expense(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: _nameCtrl.text.trim(),
                            date: _date,
                            amount: amount,
                            category: _category!,
                          );
                          context.read<ExpensesBloc>().add(ExpenseAdded(exp));
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child:
                    const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isValid {
    final nameOk = _nameCtrl.text.trim().isNotEmpty;
    final catOk = _category != null;
    final amt = double.tryParse(_amountCtrl.text.replaceAll(',', '.'));
    final amtOk = (amt ?? 0) > 0;
    return nameOk && catOk && amtOk;
  }

  void _onFormChanged() {
    // Rebuild to update Save button enable state as user types
    if (mounted) setState(() {});
  }

  void _showCategorySheet(
      BuildContext context, List<ExpenseCategory> categories) async {
    final selected = await showModalBottomSheet<ExpenseCategory>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Pilih Kategori',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    final c = categories[i];
                    return InkWell(
                      onTap: () => Navigator.of(ctx).pop(c),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.shade200,
                            child: CategoryIcon(category: c, size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(c.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted) return;
    if (selected != null) {
      setState(() => _category = selected);
    }
  }
}

String _formatDate(DateTime d) {
  return '${_weekday[d.weekday]}, ${d.day} ${_month[d.month]} ${d.year}';
}

const _weekday = {
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: "Jumat",
  6: 'Sabtu',
  7: 'Minggu',
};

const _month = {
  1: 'Januari',
  2: 'Februari',
  3: 'Maret',
  4: 'April',
  5: 'Mei',
  6: 'Juni',
  7: 'Juli',
  8: 'Agustus',
  9: 'September',
  10: 'Oktober',
  11: 'November',
  12: 'Desember',
};

// Helpers and UI bits
InputDecoration _decoration(String label, {Widget? suffixIcon}) {
  const radius = 14.0;
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: c, width: 1),
      );
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: border(Colors.black12),
    focusedBorder: border(Colors.blueAccent),
    errorBorder: border(Colors.redAccent),
    focusedErrorBorder: border(Colors.redAccent),
    suffixIcon: suffixIcon,
  );
}
