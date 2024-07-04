class ShoppingCart {
  final String code;
  final String description;
  final double quantity;
  final double price;
  final double weight;
  final double stock;

  ShoppingCart(this.code, this.quantity, this.description, this.price,
      this.weight, this.stock);

  ShoppingCart.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        description = json['description'],
        quantity = json['quntity'],
        price = json['price'],
        weight = json['weight'],
        stock = json['stock'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'quantity': quantity,
        'price': price,
        'weight': weight,
        'stock': stock
      };
}
