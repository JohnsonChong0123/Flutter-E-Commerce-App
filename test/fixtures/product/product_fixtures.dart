import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:e_commerce_client/domain/entity/product/product_details_entity.dart';
import 'package:e_commerce_client/domain/entity/product/product_summary_entity.dart';

// Product Summary
const tProductSummaryModelList = [
  ProductSummaryModel(
    id: 'v1|377049276589|645539111213',
    name:
        'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
    initialPrice: 614.99,
    finalPrice: 481.99,
    imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
  ),
  ProductSummaryModel(
    id: 'v1|386936766515|654209735321',
    name:
        'Apple iPhone 12 64/128GB - Fully Unlocked AT&T T-Mobile Verizon - All colors',
    initialPrice: 0,
    finalPrice: 219.0,
    imageUrl:
        'https://i.ebayimg.com/images/g/fe4AAOSwVkRmIHzv/s-l225.jpg',
  ),
];

final tProductSummaryEntityList = tProductSummaryModelList
    .map((model) => model.toEntity())
    .toList();

const tProductSummaryModel = ProductSummaryModel(
  id: 'v1|377049276589|645539111213',
  name:
      'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
  initialPrice: 614.99,
  finalPrice: 481.99,
  imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
);

final tProductSummaryEntity = ProductSummaryEntity(
  id: 'v1|377049276589|645539111213',
  name:
      'NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked',
  initialPrice: 614.99,
  finalPrice: 481.99,
  imageUrl: 'https://i.ebayimg.com/images/g/ZAIAAOSws5Nna86X/s-l225.jpg',
);


// Product Details
const tProductDetailsModel = ProductDetailsModel(
  id: "v1|377049276589|645539111213",
  name:
      "NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked",
  description:
      "🔥 NEW SEALED SAMSUNG GALAXY S23 ULTRA 5G FACTORY UNLOCKED GSM CDMA ALL MEMORY🔥 🎁【US IN STOCK🚚 Fast Delivery】 ✅Factory Unlocked 👍 ALL COLOR & MEMORY & CARRIER 🚚Free & Fast Shipping: 3-5 DAYS 💯Brand-New in Sealed Box 🤩Free Exchange in 60 days 🤝 2 Years Warranty.",
  finalPrice: 481.99,
  imageUrl:
      "https://i.ebayimg.com/images/g/i20AAOSwvxpna86j/s-l1600.jpg"
);

final tProductDetailsEntity = ProductDetailsEntity(
  id: "v1|377049276589|645539111213",
  name:
      "NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked",
  description:
      "🔥 NEW SEALED SAMSUNG GALAXY S23 ULTRA 5G FACTORY UNLOCKED GSM CDMA ALL MEMORY🔥 🎁【US IN STOCK🚚 Fast Delivery】 ✅Factory Unlocked 👍 ALL COLOR & MEMORY & CARRIER 🚚Free & Fast Shipping: 3-5 DAYS 💯Brand-New in Sealed Box 🤩Free Exchange in 60 days 🤝 2 Years Warranty.",
  finalPrice: 481.99,
  imageUrl:
      "https://i.ebayimg.com/images/g/i20AAOSwvxpna86j/s-l1600.jpg"
);

const tProductId = "v1|377049276589|645539111213";
