import '../../core/extensions/currency_extension.dart';
import '../../domain/entity/product/product_details_entity.dart';
import '../models/product_display_aspect.dart';

class ProductDetailsMapper {
  static List<ProductDisplayAspect> mapAspects(
    ProductDetailsEntity product,
  ) {
    return product.localizedAspects
        .where(
          (aspect) =>
              aspect.type.toString().toLowerCase().contains('string') &&
              aspect.name.toString().trim().isNotEmpty,
        )
        .map(
          (aspect) => ProductDisplayAspect(
            name: aspect.name.toString(),
            value: aspect.value.toString(),
          ),
        )
        .toList();
  }

  static Map<String, List<ProductDisplayAspect>> mapShippingAspects(
    ProductDetailsEntity product,
  ) {
    final Map<String, List<ProductDisplayAspect>> groups = {};

    for (final opt in product.shippingOptions) {
      final servicePrefix = opt.shippingServiceCode.trim().isNotEmpty
          ? opt.shippingServiceCode.trim()
          : (opt.type.trim().isNotEmpty ? opt.type.trim() : '');

      final shippingCost = opt.shippingCost != null
          ? opt.shippingCost!.value.formatCurrency(
              opt.shippingCost!.currency,
            )
          : 'N/A';

      final additional = opt.additionalShippingCostPerUnit != null
          ? opt.additionalShippingCostPerUnit!.value.formatCurrency(
              opt.additionalShippingCostPerUnit!.currency,
            )
          : 'N/A';

      final qty = opt.quantityUsedForEstimate?.toString() ?? 'N/A';

      final costType = opt.shippingCostType ?? 'N/A';

      groups.putIfAbsent(servicePrefix, () => []).addAll([
        ProductDisplayAspect(name: 'Cost', value: shippingCost),
        ProductDisplayAspect(name: 'Addition Cost / Unit', value: additional),
        ProductDisplayAspect(name: 'Qty (estimate)', value: qty),
        ProductDisplayAspect(name: 'Cost Type', value: costType),
      ]);
    }

    return groups;
  }
}