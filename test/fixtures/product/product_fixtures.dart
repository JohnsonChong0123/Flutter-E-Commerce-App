import 'package:e_commerce_client/data/models/product/localized_aspect_model.dart';
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
final tProductDetailsModel = ProductDetailsModel(
  id: "v1|377049276589|645539111213",
  name:
      "NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked",
  description:
      "🔥 NEW SEALED SAMSUNG GALAXY S23 ULTRA 5G FACTORY UNLOCKED GSM CDMA ALL MEMORY🔥 🎁【US IN STOCK🚚 Fast Delivery】 ✅Factory Unlocked 👍 ALL COLOR & MEMORY & CARRIER 🚚Free & Fast Shipping: 3-5 DAYS 💯Brand-New in Sealed Box 🤩Free Exchange in 60 days 🤝 2 Years Warranty.",
  finalPrice: 481.99,
  currency: "USD",
  imageUrl: "https://i.ebayimg.com/images/g/i20AAOSwvxpna86j/s-l1600.jpg",
  additionalImages: [
    "https://i.ebayimg.com/images/g/7CwAAOSwu2Zna86k/s-l1600.jpg",
    "https://i.ebayimg.com/images/g/caIAAOSwRX5na86k/s-l1600.jpg",
  ],
  localizedAspects: tLocalizedAspects
);

final tProductDetailsEntity = ProductDetailsEntity(
  id: "v1|377049276589|645539111213",
  name:
      "NEW SEALED Samsung Galaxy S23 Ultra 5G SM-S918U 1T/256GB/512GB Factory Unlocked",
  description:
      "🔥 NEW SEALED SAMSUNG GALAXY S23 ULTRA 5G FACTORY UNLOCKED GSM CDMA ALL MEMORY🔥 🎁【US IN STOCK🚚 Fast Delivery】 ✅Factory Unlocked 👍 ALL COLOR & MEMORY & CARRIER 🚚Free & Fast Shipping: 3-5 DAYS 💯Brand-New in Sealed Box 🤩Free Exchange in 60 days 🤝 2 Years Warranty.",
  finalPrice: 481.99,
  currency: "USD",
  imageUrl: "https://i.ebayimg.com/images/g/i20AAOSwvxpna86j/s-l1600.jpg",
  additionalImages: [
    "https://i.ebayimg.com/images/g/7CwAAOSwu2Zna86k/s-l1600.jpg",
    "https://i.ebayimg.com/images/g/caIAAOSwRX5na86k/s-l1600.jpg",
  ],
  localizedAspects: tLocalizedAspects.map((e) => e.toEntity()).toList(),
);

const tProductId = "v1|377049276589|645539111213";

const tLocalizedAspects = [
  LocalizedAspectModel(type: "STRING", name: "CAPACITY", value: "512GB"),
  LocalizedAspectModel(type: "STRING", name: "Color", value: "Green"),
  LocalizedAspectModel(type: "STRING", name: "Lock Status", value: "T-Mobile Unlocked"),
  LocalizedAspectModel(type: "STRING", name: "Processor", value: "Qual Comm"),
  LocalizedAspectModel(type: "STRING", name: "Screen Size", value: "6.8 in"),
  LocalizedAspectModel(type: "STRING", name: "Manufacturer Color", value: "Black, Cream, Green, Purple, Graphite, Lime, Bue, Red"),
  LocalizedAspectModel(type: "STRING", name: "Custom Bundle", value: "No"),
  LocalizedAspectModel(type: "STRING", name: "MPN", value: "SM-S918UZKAXAA, SM-S918UZEAXAA, SM-S918UZGAXAA, SM-S918ULIAXAA, SM-S918UZKFXAA, SM-S918UZEFXAA, SM-S918UZGFXAA, SM-S918ULIFXAA, SM-S918UZKNXAA"),
  LocalizedAspectModel(type: "STRING", name: "Model Number", value: "SM-S918U"),
  LocalizedAspectModel(type: "STRING", name: "SIM Card Slot", value: "eSIM"),
  LocalizedAspectModel(type: "STRING", name: "Brand", value: "Samsung"),
  LocalizedAspectModel(type: "STRING", name: "Manufacturer Warranty", value: "Other: see item description"),
  LocalizedAspectModel(type: "STRING", name: "Network", value: "AT&T, Cricket Wireless, Metro PCs, Net 10, SIMPLE Mobile, T-Mobile, Unlocked, Verizon"),
  LocalizedAspectModel(type: "STRING", name: "Model", value: "Samsung Galaxy S23 Ultra"),
  LocalizedAspectModel(type: "STRING", name: "Style", value: "Bar"),
  LocalizedAspectModel(type: "STRING", name: "Connectivity", value: "5G"),
  LocalizedAspectModel(type: "STRING", name: "Operating System", value: "Android 13"),
  LocalizedAspectModel(type: "STRING", name: "Features", value: "Air Gesture, Internet Browser, Touchscreen, 3G Data Capable, 4G Data Capable, Bluetooth Enabled, Fingerprint Sensor, Global Ready, GPS, Music Player, Speakerphone, Wi-Fi Capable"),
  LocalizedAspectModel(type: "STRING", name: "Storage Capacity", value: "256 GB, 512 GB, 1024 GB"),
  LocalizedAspectModel(type: "STRING", name: "Contract", value: "Without Contract"),
  LocalizedAspectModel(type: "STRING", name: "Camera Resolution", value: "50 MP"),
  LocalizedAspectModel(type: "STRING", name: "RAM", value: "12 GB"),
];
