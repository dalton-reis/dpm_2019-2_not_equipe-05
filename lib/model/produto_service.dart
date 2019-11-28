import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantocusta/model/produto.dart';

class ProdutoService {
  final db = Firestore.instance;

  Future<List<Produto>> buscarProdutosNovaSala(
      int quantidadeInteiros, int quantidadeDecimais) {
    return this.getCollection().getDocuments().then((documentsRef) {
      documentsRef.documents.shuffle();
      List<Produto> produtos = [];
      int countInt = 0;
      int countDec = 0;
      for (DocumentSnapshot document in documentsRef.documents) {
        Produto p = new Produto.fromDocument(document);
        if (p.inteiro && countInt < quantidadeInteiros) {
          produtos.add(p);
          countInt++;
        }
        if (!p.inteiro && countDec < quantidadeDecimais) {
          produtos.add(p);
          countDec++;
        }

        if (quantidadeDecimais == countDec && quantidadeInteiros == countInt) {
          break;
        }
      }
      return produtos;
    });
  }

  CollectionReference getCollection() {
    return db.collection("produtos");
  }
}
