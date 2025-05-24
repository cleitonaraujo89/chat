// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Para obter o UID do usuário, se necessário para filtrar/precache
// import 'package:flutter/material.dart'; // Para precacheImage
// import 'dart:async'; // Para StreamSubscription

// class MessageProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;

//   List<QueryDocumentSnapshot> _messages = []; // Lista de mensagens carregadas
//   bool _isLoadingMore = false; // Estado de carregamento de mais mensagens
//   bool _hasMoreMessages =
//       true; // Indica se ainda há mais mensagens para carregar
//   DocumentSnapshot? _lastDocument; // O último documento da última carga
//   final int _pageSize =
//       20; // Quantidade de mensagens por carga (ajuste conforme necessário)

//   StreamSubscription? _newMessageSubscription; // Para ouvir novas mensagens

//   MessageProvider(this._firestore, this._auth);

//   List<QueryDocumentSnapshot> get messages => _messages;
//   bool get isLoadingMore => _isLoadingMore;
//   bool get hasMoreMessages => _hasMoreMessages;

//   // Método para carregar as mensagens iniciais
//   Future<void> fetchInitialMessages(BuildContext context) async {
//     if (_isLoadingMore) return; // Evita múltiplas chamadas simultâneas
//     _isLoadingMore = true;
//     _hasMoreMessages = true; // Reseta ao carregar inicial
//     notifyListeners();

//     try {
//       // Limpa as mensagens antigas para uma nova sessão/tela
//       _messages.clear();

//       QuerySnapshot querySnapshot = await _firestore
//           .collection('chat')
//           .orderBy('createdAt', descending: true)
//           .limit(_pageSize)
//           .get();

//       _messages = querySnapshot.docs;
//       _lastDocument = _messages.isNotEmpty ? _messages.last : null;
//       _hasMoreMessages = querySnapshot.docs.length == _pageSize;

//       // Pré-carregar imagens das mensagens iniciais
//       await _precacheImages(_messages, context);
//       print('Mensagens iniciais carregadas e imagens pré-cache');

//       // Inicia a escuta de novas mensagens, a partir do createdAt da primeira mensagem carregada
//       _startNewMessageListener(
//           _messages.isNotEmpty ? _messages.first['createdAt'] : Timestamp.now(),
//           context);
//     } catch (e) {
//       print('Erro ao carregar mensagens iniciais: $e');
//       // Trate o erro conforme a necessidade
//     } finally {
//       _isLoadingMore = false;
//       notifyListeners();
//     }
//   }

//   // Método para carregar mais mensagens (rolagem para cima)
//   Future<void> fetchMoreMessages(BuildContext context) async {
//     if (_isLoadingMore || !_hasMoreMessages)
//       return; // Evita múltiplas chamadas ou se não houver mais mensagens
//     _isLoadingMore = true;
//     notifyListeners();

//     try {
//       Query query = _firestore
//           .collection('chat')
//           .orderBy('createdAt', descending: true)
//           .limit(_pageSize);

//       if (_lastDocument != null) {
//         query = query.startAfterDocument(_lastDocument!);
//       }

//       QuerySnapshot querySnapshot = await query.get();

//       if (querySnapshot.docs.isEmpty) {
//         _hasMoreMessages = false; // Não há mais mensagens
//       } else {
//         _messages.addAll(querySnapshot
//             .docs); // Adiciona ao final da lista (que está em ordem decrescente)
//         _lastDocument = querySnapshot.docs.last;
//         _hasMoreMessages = querySnapshot.docs.length == _pageSize;

//         // Pré-carregar imagens das novas mensagens
//         await _precacheImages(querySnapshot.docs, context);
//       }
//       print('Mais mensagens carregadas. Total: ${_messages.length}');
//     } catch (e) {
//       print('Erro ao carregar mais mensagens: $e');
//     } finally {
//       _isLoadingMore = false;
//       notifyListeners();
//     }
//   }

//   // Escuta por novas mensagens em tempo real
//   void _startNewMessageListener(
//       Timestamp latestTimestamp, BuildContext context) {
//     _newMessageSubscription?.cancel(); // Cancela qualquer escuta anterior

//     _newMessageSubscription = _firestore
//         .collection('chat')
//         .orderBy('createdAt', descending: true)
//         .where('createdAt',
//             isGreaterThan: latestTimestamp) // Apenas mensagens mais novas
//         .snapshots()
//         .listen((snapshot) async {
//       List<QueryDocumentSnapshot> newMessages = snapshot.docs;
//       if (newMessages.isNotEmpty) {
//         // Adiciona as novas mensagens ao *início* da lista,
//         // pois ela está em ordem decrescente (mais novas no início)
//         _messages.insertAll(0, newMessages);
//         await _precacheImages(newMessages,
//             context as BuildContext); // Precisa do context, veja o final.
//         notifyListeners();
//         print('Novas mensagens em tempo real recebidas: ${newMessages.length}');
//       }
//     }, onError: (error) {
//       print('Erro no listener de novas mensagens: $error');
//     });
//   }

//   // Função auxiliar para pré-carregar imagens
//   Future<void> _precacheImages(
//       List<QueryDocumentSnapshot> docs, BuildContext context) async {
//     for (final doc in docs) {
//       final imageUrl = doc['userImage'] as String?;
//       if (imageUrl != null && imageUrl.isNotEmpty) {
//         try {
//           await precacheImage(NetworkImage(imageUrl), context);
//         } catch (e) {
//           print('Erro ao pré-carregar imagem $imageUrl: $e');
//           // Pode continuar mesmo se uma imagem falhar
//         }
//       }
//     }
//   }

//   // Método para adicionar uma mensagem que o próprio usuário enviou (opcional, mas útil para feedback imediato)
//   void addSentMessage(QueryDocumentSnapshot message) {
//     _messages.insert(
//         0, message); // Adiciona ao topo para que apareça imediatamente
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _newMessageSubscription
//         ?.cancel(); // Cancela a escuta ao descartar o provider
//     super.dispose();
//   }
// }
