import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../core/routes/app_router.dart';
import '../../cubits/wishlist/wishlist_cubit.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        if (state is WishlistLoading) {
          return Scaffold(body: const Loader());
        } else if (state is WishlistLoaded) {
          final wishlist = state.wishlist;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Wishlist',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<WishlistCubit>().clearWishlist();
                  },
                ),
              ],
            ),
            body: wishlist.isEmpty
                ? const Center(child: Text('Wishlist is empty'))
                : SlidableAutoCloseBehavior(
                    child: ListView.builder(
                      itemCount: wishlist.length,
                      itemBuilder: (context, index) {
                        final item = wishlist[index];
                        return Slidable(
                          key: Key(item.productId.toString()),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  context.read<WishlistCubit>().removeWishlist(
                                    item.productId,
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                AppRouter.productDetailsName,
                                pathParameters: {'id': item.productId},
                              );
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CachedNetworkImage(
                                    imageUrl: item.imageUrl,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    placeholder: (context, url) => Container(
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(fontSize: 15),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$${item.finalPrice.toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          );
        } else if (state is WishlistFailure) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
