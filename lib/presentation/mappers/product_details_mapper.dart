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

  static List<ProductDisplayAspect> mapShippingAspects(
    ProductDetailsEntity product,
  ) {
    return product.shippingOptions.expand((opt) {
      final servicePrefix = opt.shippingServiceCode.trim().isNotEmpty
          ? '${opt.shippingServiceCode} - '
          : '';

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

      return [
        ProductDisplayAspect(
          name: '${servicePrefix}Shipping Cost',
          value: shippingCost,
        ),
        ProductDisplayAspect(
          name: '${servicePrefix}Additional Shipping Cost Per Unit',
          value: additional,
        ),
        ProductDisplayAspect(
          name: '${servicePrefix}Quantity Used For Estimate',
          value: qty,
        ),
        ProductDisplayAspect(
          name: '${servicePrefix}Shipping Cost Type',
          value: costType,
        ),
      ];
    }).toList();
  }
}