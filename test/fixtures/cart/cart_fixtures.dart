import 'package:e_commerce_client/data/models/cart/cart_item_model.dart';
import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:e_commerce_client/domain/entity/cart_entity.dart';
import 'package:e_commerce_client/domain/entity/cart_item_entity.dart';

const tCartModel = CartModel(
  id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
  items: [
    CartItemModel(
      productId: 'v1|377049276589|645539111213',
      name:
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
      price: 481.99,
      quantity: 3,
      imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
    ),
    CartItemModel(
      productId: 'v1|386936766515|654209735321',
      name:
          'Apple iPhone 12 64/128GB - Fully Unlocked AT&T T-Mobile Verizon - All colors',
      price: 219.0,
      quantity: 3,
      imageUrl: 'https://i.ebayimg.com/images/g/fe4AAOSwVkRmIHzv/s-l225.jpg',
    ),
  ],
  cartTotal: 2102.97,
);

const tCartItemModel = CartItemModel(
  productId: 'v1|377049276589|645539111213',
  name:
      'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
  price: 481.99,
  quantity: 3,
  imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
);

const tCartEntity = CartEntity(
  id: '1d3ed0a0-b460-4137-81b6-7e4befc3b63b',
  items: [
    CartItemEntity(
      productId: 'v1|377049276589|645539111213',
      name:
          'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
      price: 481.99,
      quantity: 3,
      imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
    ),
    CartItemEntity(
      productId: 'v1|386936766515|654209735321',
      name:
          'Apple iPhone 12 64/128GB - Fully Unlocked AT&T T-Mobile Verizon - All colors',
      price: 219.0,
      quantity: 3,
      imageUrl: 'https://i.ebayimg.com/images/g/fe4AAOSwVkRmIHzv/s-l225.jpg',
    ),
  ],
  cartTotal: 2102.97,
);


