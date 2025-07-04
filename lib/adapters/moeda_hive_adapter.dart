import 'package:hive/hive.dart';

import '../models/moeda.dart';

class MoedaHiveAdapter extends TypeAdapter<Moeda> {
  @override
  final typeId = 0;

  @override
  Moeda read(BinaryReader reader) {
    return Moeda(
      icone: reader.readString(),
      nome: reader.readString(),
      preco: reader.readDouble(),
      sigla: reader.readString(),
      dolarPreco: reader.readDouble(),
      favorito: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Moeda obj) {
    writer.writeString(obj.icone);
    writer.writeString(obj.nome);
    writer.writeDouble(obj.preco);
    writer.writeString(obj.sigla);
    writer.writeDouble(obj.dolarPreco);
    writer.writeInt(obj.favorito);
  }
}
