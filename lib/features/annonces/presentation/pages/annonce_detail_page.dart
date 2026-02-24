import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:secondmain_237/features/chat/presentation/bloc/chat_event.dart';
import 'package:secondmain_237/features/chat/presentation/bloc/chat_state.dart';
import 'package:secondmain_237/features/chat/presentation/pages/chat_page.dart';
import '../../domain/entities/annonce.dart';
import '../bloc/annonce_bloc.dart';
import '../bloc/annonce_event.dart';
import '../bloc/annonce_state.dart';
import 'package:secondmain_237/core/constants/api_constants.dart';
import 'package:secondmain_237/core/network/dio_client.dart';
import 'package:secondmain_237/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:secondmain_237/features/orders/data/repositories/order_repository_impl.dart';
import 'package:secondmain_237/features/orders/domain/entities/order.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnonceDetailPage extends StatefulWidget {
  final String annonceId;

  const AnnonceDetailPage({Key? key, required this.annonceId})
      : super(key: key);

  @override
  State<AnnonceDetailPage> createState() => _AnnonceDetailPageState();
}

class _AnnonceDetailPageState extends State<AnnonceDetailPage> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    final id = int.tryParse(widget.annonceId);
    if (id != null) {
      context.read<AnnonceBloc>().add(GetAnnonceByIdEvent(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<AnnonceBloc, AnnonceState>(
        builder: (context, state) {
          if (state is AnnonceLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is AnnonceError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          } else if (state is AnnonceDetailLoaded) {
            return _buildContent(state.annonce);
          }
          // Si l'état n'est pas encore chargé (ou autre état), on affiche un loader
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        },
      ),
    );
  }

  Widget _buildContent(Annonce annonce) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildAppBar(annonce),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(annonce),
                    const SizedBox(height: 16),
                    _buildDescription(annonce),
                    const SizedBox(height: 24),
                    _buildSellerInfo(annonce),
                    const SizedBox(height: 100), // Espace pour le bouton du bas
                  ],
                ),
              ),
            ),
          ],
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildAppBar(Annonce annonce) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (annonce.images.isNotEmpty)
              PageView.builder(
                itemCount: annonce.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final imagePath = annonce.images[index];
                  // Gestion basique : si commence par http -> Network, sinon File (si on supporte le local preview)
                  // Ici on assume que ça vient du backend donc URL
                  return Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  );
                },
              )
            else
              Container(
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.image, size: 80, color: Colors.white)),

            // Indicateur de page
            if (annonce.images.length > 1)
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1}/${annonce.images.length}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.8),
            child: IconButton(
              icon: Icon(
                annonce.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: annonce.isFavorite ? AppColors.error : Colors.black,
              ),
              onPressed: () {
                context
                    .read<AnnonceBloc>()
                    .add(ToggleFavoriteEvent(annonce.id));
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Annonce annonce) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                annonce.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
            Text(
              '${annonce.price.toStringAsFixed(0)} FCFA',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              annonce.location,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                annonce.condition,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(Annonce annonce) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          annonce.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildSellerInfo(Annonce annonce) {
    final seller = annonce.seller;
    if (seller == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
                seller.avatar != null ? NetworkImage(seller.avatar!) : null,
            child: seller.avatar == null
                ? Text(seller.fullName[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Vendeur',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BlocBuilder<AnnonceBloc, AnnonceState>(
          builder: (context, state) {
            final annonce = state is AnnonceDetailLoaded ? state.annonce : null;
            return Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final bloc = context.read<AnnonceBloc>().state;
                      if (bloc is AnnonceDetailLoaded &&
                          bloc.annonce.seller != null) {
                        final sellerId = bloc.annonce.seller!.id;
                        context
                            .read<ChatBloc>()
                            .add(CreateOrGetConversationEvent(
                              receiverId: sellerId,
                              annonceId: int.tryParse(widget.annonceId),
                            ));
                      }
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone),
                    label: const Text('Appeler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        annonce == null ? null : () => _startCheckout(annonce),
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('Acheter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _startCheckout(Annonce annonce) async {
    final methods = [
      {'key': 'cod', 'label': 'Paiement à la livraison'},
      {'key': 'mobile_money', 'label': 'Mobile Money'},
      {'key': 'card', 'label': 'Carte bancaire'},
    ];
    String selected = 'cod';
    int quantity = 1;
    final operators = [
      {'key': 'Orange_Cameroon', 'label': 'Orange Money'},
      {'key': 'MTN_Cameroon', 'label': 'MTN MoMo'},
    ];
    String selectedOperator = 'Orange_Cameroon';
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Confirmer l’achat',
                      style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Quantité'),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setModalState(() => quantity--);
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {
                          setModalState(() => quantity++);
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: methods.map((m) {
                      return RadioListTile<String>(
                        value: m['key']!,
                        groupValue: selected,
                        onChanged: (v) =>
                            setModalState(() => selected = v ?? 'cod'),
                        title: Text(m['label']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: operators.map((o) {
                      return RadioListTile<String>(
                        value: o['key']!,
                        groupValue: selectedOperator,
                        onChanged: (v) => setModalState(
                            () => selectedOperator = v ?? 'Orange_Cameroon'),
                        title: Text(o['label']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Payer'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        );
      },
    );
    if (confirmed != true) return;
    final repo = OrderRepositoryImpl(
        remoteDataSource: OrderRemoteDataSource(client: DioClient()));
    try {
      final created = await repo.createOrder(
        annonceId: annonce.id,
        quantity: quantity,
        paymentMethod: selected,
      );
      await created.fold(
        (l) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.message)),
          );
        },
        (order) async {
          // Initier le paiement côté passerelle (URL de redirection)
          final urlEither = await repo.initiatePaymentUrl(
              orderId: order.id, operator: selectedOperator);
          await urlEither.fold(
            (l) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.message)),
              );
            },
            (paymentUrl) async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Redirection vers la page de paiement…')));
              final uri = Uri.parse(paymentUrl);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          );
          final statusRepo = repo;
          // Démarrer un polling pour mettre à jour l’état (webhook mettra à jour côté serveur)
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(const SnackBar(
              content: Text('Redirection vers la page de paiement…')));
          // Lancement du navigateur: l’URL est fournie par l’API au moment de l’initiation,
          // mais notre repository renvoie l’ordre; on démarre ensuite un polling.
          // On peut aussi afficher une dialog indiquant de revenir après paiement.
          int attempts = 0;
          const maxAttempts = 15; // ~30s si 2s
          Timer.periodic(const Duration(seconds: 2), (timer) async {
            attempts++;
            final statusEither =
                await statusRepo.getOrderStatus(orderId: order.id);
            statusEither.fold(
              (_) {},
              (status) {
                final s = status['orderStatus'];
                if (s == 'paid') {
                  timer.cancel();
                  messenger.showSnackBar(
                      const SnackBar(content: Text('Paiement confirmé')));
                  context
                      .read<AnnonceBloc>()
                      .add(GetAnnonceByIdEvent(annonce.id));
                } else if (s == 'canceled') {
                  timer.cancel();
                  messenger.showSnackBar(
                      const SnackBar(content: Text('Paiement annulé')));
                }
              },
            );
            if (attempts >= maxAttempts) {
              timer.cancel();
            }
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
}
