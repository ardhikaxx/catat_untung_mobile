enum UnitType {
  pcs('pcs'),
  unit('unit'),
  botol('botol'),
  kg('kg'),
  paket('paket'),
  porsi('porsi'),
  liter('liter'),
  meter('meter'),
  lusin('lusin'),
  box('box'),
  custom('custom');

  const UnitType(this.label);
  final String label;
}
