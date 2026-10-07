import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/nova_button.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/app_state_providers.dart';
import '../../orders/presentation/delivery_tracking_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep =
      1; // 1 = Address, 2 = Delivery, 3 = Payment, 4 = Confirmation
  int _selectedAddressIdx = 0;
  String _selectedPaymentMethod = 'UPI (Google Pay / PhonePe)';
  bool _isProcessing = false;
  OrderModel? _placedOrder;

  void _placeOrder() async {
    setState(() => _isProcessing = true);
    await Future.delayed(
      const Duration(milliseconds: 1500),
    ); // Simulating gateway

    final cartState = ref.read(cartProvider);
    final user = ref.read(userProvider);
    final address = user.addresses[_selectedAddressIdx].fullAddress;

    final newOrder = OrderModel(
      orderId:
          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      items: cartState.activeItems,
      currentStatus: OrderStatus.confirmed,
      timeline: [
        OrderStep(
          status: OrderStatus.placed,
          title: 'Order Placed',
          subtitle: 'Payment confirmed via $_selectedPaymentMethod',
          timestamp: DateTime.now(),
          isCompleted: true,
        ),
        OrderStep(
          status: OrderStatus.confirmed,
          title: 'Seller Confirmed',
          subtitle: 'Merchant is packing items',
          timestamp: DateTime.now().add(const Duration(minutes: 15)),
          isCompleted: true,
        ),
        OrderStep(
          status: OrderStatus.shipped,
          title: 'In Transit',
          subtitle: 'Handed over to BlueDart',
          timestamp: DateTime.now().add(const Duration(hours: 4)),
          isCompleted: false,
        ),
        OrderStep(
          status: OrderStatus.delivered,
          title: 'Delivered',
          subtitle: 'Expected tomorrow by 5:00 PM',
          timestamp: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
        ),
      ],
      totalAmount: cartState.grandTotal,
      paymentMethod: _selectedPaymentMethod,
      shippingAddress: address,
      trackingId:
          'BD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}-IN',
      courierPartner: 'BlueDart Express',
      estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
    );

    ref.read(ordersProvider.notifier).addOrder(newOrder);
    ref.read(cartProvider.notifier).clearCart();

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _placedOrder = newOrder;
        _currentStep = 4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentStep == 4 ? "Order Confirmed! 🎉" : "Checkout"),
      ),
      body: _currentStep == 4 && _placedOrder != null
          ? _buildConfirmationScreen(_placedOrder!)
          : Column(
              children: [
                // Step Progress Indicator
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _stepIndicator(1, "Address"),
                      _stepLine(1),
                      _stepIndicator(2, "Delivery"),
                      _stepLine(2),
                      _stepIndicator(3, "Payment"),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentStep == 1) _buildAddressStep(user),
                        if (_currentStep == 2) _buildDeliveryStep(),
                        if (_currentStep == 3) _buildPaymentStep(cartState),
                      ],
                    ),
                  ),
                ),

                // Bottom Step Action Bar
                if (_currentStep < 4)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 1)
                          NovaButton(
                            label: "Back",
                            variant: NovaButtonVariant.outline,
                            onPressed: () => setState(() => _currentStep--),
                          )
                        else
                          const SizedBox(),
                        NovaButton(
                          label: _currentStep == 3
                              ? "Pay ${CurrencyFormatter.format(cartState.grandTotal)}"
                              : "Continue",
                          isLoading: _isProcessing,
                          onPressed: () {
                            if (_currentStep == 3) {
                              _placeOrder();
                            } else {
                              setState(() => _currentStep++);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _stepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive
              ? AppColors.primary
              : Colors.grey.withValues(alpha: 0.3),
          child: Text(
            '$step',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(int step) {
    final isActive = _currentStep > step;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 24,
      height: 2,
      color: isActive ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
    );
  }

  Widget _buildAddressStep(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SELECT DELIVERY ADDRESS",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        RadioGroup<int>(
          groupValue: _selectedAddressIdx,
          onChanged: (val) {
            if (val != null) setState(() => _selectedAddressIdx = val);
          },
          child: Column(
            children: List.generate(user.addresses.length, (idx) {
              final addr = user.addresses[idx];
              final isSelected = _selectedAddressIdx == idx;
              return GestureDetector(
                onTap: () => setState(() => _selectedAddressIdx = idx),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    borderColor: isSelected ? AppColors.primary : null,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: idx,
                        ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                addr.recipientName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  addr.label,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addr.fullAddress,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                          Text(
                            "Phone: ${addr.phone}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.darkTextTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ),
  ],
);
  }

  Widget _buildDeliveryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CHOOSE DELIVERY SPEED",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          borderColor: AppColors.primary,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: const Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: AppColors.flashDealTimer,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Express Priority Delivery (FREE)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Guaranteed delivery by tomorrow 5:00 PM",
                      style: TextStyle(fontSize: 12, color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStep(CartState cartState) {
    final paymentMethods = [
      'UPI (Google Pay / PhonePe / Paytm / BHIM)',
      'Credit / Debit Card (Visa, Mastercard, RuPay)',
      'Net Banking (All Indian Banks)',
      'Cash on Delivery (COD)',
      'No Cost EMI',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SELECT PAYMENT METHOD",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        RadioGroup<String>(
          groupValue: _selectedPaymentMethod,
          onChanged: (val) {
            if (val != null) setState(() => _selectedPaymentMethod = val);
          },
          child: Column(
            children: paymentMethods.map((pm) {
              final isSelected = _selectedPaymentMethod == pm;
              return GestureDetector(
                onTap: () => setState(() => _selectedPaymentMethod = pm),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    borderColor: isSelected ? AppColors.primary : null,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: pm,
                        ),
                    Expanded(
                      child: Text(
                        pm,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  ],
);
  }

  Widget _buildConfirmationScreen(OrderModel order) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 56,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Order ${order.orderId}",
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkTextTertiary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Thank You for Your Order!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Paid: ${CurrencyFormatter.format(order.totalAmount)} via ${order.paymentMethod}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            NovaButton(
              label: "Track Live Order",
              isFullWidth: true,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryTrackingScreen(order: order),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            NovaButton(
              label: "Back to Home",
              variant: NovaButtonVariant.outline,
              isFullWidth: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
