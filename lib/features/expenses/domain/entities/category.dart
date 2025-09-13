enum ExpenseCategory {
  food('Makanan', 'assets/categories/makanan.png', '🍽️'),
  internet('Internet', 'assets/categories/internet.png', '🌐'),
  transport('Transportasi', 'assets/categories/transport.png', '🚌'),
  education('Edukasi', 'assets/categories/edukasi.png', '📚'),
  gift('Hadiah', 'assets/categories/hadiah.png', '🎁'),
  shopping('Belanja', 'assets/categories/belanja.png', '🛍️'),
  home('Alat Rumah', 'assets/categories/alatrumah.png', '🏠'),
  sport('Olahraga', 'assets/categories/olahraga.png', '🏃‍♂️'),
  entertainment('Hiburan', 'assets/categories/hiburan.png', '🎬');

  const ExpenseCategory(this.label, this.assetPath, this.emojiFallback);
  final String label;
  final String assetPath;
  final String emojiFallback; // used if asset missing
}
