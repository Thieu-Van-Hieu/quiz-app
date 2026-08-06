import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/button/switch.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/features/setting/constants/keymaps.dart';
import 'package:frontend/features/setting/enums/physical_key.dart';
import 'package:frontend/features/setting/enums/shortcut_action.dart';
import 'package:frontend/features/setting/models/app_config.dart';
import 'package:frontend/features/setting/notifiers/app_config_notifier.dart';
import 'package:frontend/features/setting/widgets/setting_group_card.dart';
import 'package:frontend/features/setting/widgets/setting_link_tile.dart';
import 'package:frontend/features/setting/widgets/setting_tile.dart';
import 'package:frontend/features/setting/widgets/shortcut_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  void _update(WidgetRef ref, AppConfig config) {
    final container = ProviderScope.containerOf(ref.context);
    container.read(appConfigProvider.notifier).updateConfig(config);
    container.invalidate(watchAppConfigProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(watchAppConfigProvider);

    return configAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("${AppStrings.error}: $err")),
      data: (config) {
        if (config == null) {
          Future.microtask(() {
            ref.read(appConfigProvider.notifier).initAppConfig();
          });

          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Đang khởi tạo cấu hình lần đầu..."),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: CustomScrollView(
            slivers: [
              _buildHeader(),

              _buildSectionTitle("Giao diện"),
              SliverToBoxAdapter(
                child: SettingGroupCard(
                  children: [
                    SettingTile(
                      icon: Icons.font_download_outlined,
                      title: "Font chữ",
                      trailing: Text(
                        config.fontFamily,
                        style: TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                          fontFamily: config.fontFamily,
                        ),
                      ),
                      onTap: () => _showFontPicker(context, ref, config),
                    ),
                    const Divider(height: 1, indent: 50),
                    SettingTile(
                      icon: Icons.format_size_rounded,
                      title: "Kích thước chữ",
                      trailing: Text(
                        "${config.fontSize.toInt()} px",
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _showFontSizePicker(context, ref, config),
                    ),
                  ],
                ),
              ),

              _buildSectionTitle("Điều khiển"),
              SliverToBoxAdapter(
                child: SettingGroupCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phím tắt nhanh (A-Z)",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Chọn đáp án ngay lập tức",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          AppSwitch(
                            label: "",
                            value: config.enableQuickAnswer,
                            onChanged: (val) {
                              config.enableQuickAnswer = val;
                              _update(ref, config);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, indent: 50),
                    ...ShortcutAction.values.map(
                      (action) => ShortcutTile(
                        label: action.label,
                        assignedKeys: config.keyBindings[action] ?? [],
                        onTap: () =>
                            _showBindingDialog(context, ref, config, action),
                        onRemoveKey: (key) =>
                            _removeKey(ref, config, action, key),
                      ),
                    ),
                  ],
                ),
              ),

              _buildSectionTitle("Dự án & Tác giả"),
              SliverToBoxAdapter(
                child: SettingGroupCard(
                  children: [
                    SettingLinkTile(
                      icon: Icons.coffee_rounded,
                      title: "Buy me a coffee",
                      subtitle: "Ủng hộ tác giả duy trì QuizApp",
                      onTap: () => _showDonateDialog(context),
                    ),
                    const Divider(height: 1, indent: 50),
                    SettingLinkTile(
                      icon: Icons.code_rounded,
                      title: "GitHub Repository",
                      subtitle: AppStrings.githubRepoUrl,
                      onTap: () =>
                          launchUrl(Uri.parse(AppStrings.githubRepoUrl)),
                    ),
                  ],
                ),
              ),

              _buildSectionTitle("Dữ liệu"),
              SliverToBoxAdapter(
                child: SettingGroupCard(
                  children: [
                    SettingTile(
                      icon: Icons.delete_sweep_rounded,
                      title: "Xóa dữ liệu học tập",
                      iconColor: AppColors.orange,
                      onTap: () => _showResetConfirm(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- LOGIC HELPER ---

  void _removeKey(
    WidgetRef ref,
    AppConfig config,
    ShortcutAction action,
    PhysicalKey key,
  ) {
    final currentMap = Map<ShortcutAction, List<PhysicalKey>>.from(
      config.keyBindings,
    );
    final List<PhysicalKey> keys = List.from(currentMap[action] ?? []);
    if (keys.remove(key)) {
      currentMap[action] = keys;
      config.keyBindings = currentMap;
      _update(ref, config);
    }
  }

  // 🔥 CUSTOM FONT SIZE PICKER DIALOG (Mới hoàn toàn)
  void _showFontSizePicker(
    BuildContext context,
    WidgetRef ref,
    AppConfig config,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final currentSize = config.fontSize;

          return AppAlertDialog(
            title: "Kích thước phông chữ",
            size: AlertDialogSize.small,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Khung xem trước Font Size (Live Preview)
                Container(
                  height: 90,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brand.withValues(alpha: 0.2),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      "Mẫu văn bản hiển thị (${currentSize.toInt()}px)",
                      style: TextStyle(
                        fontSize: currentSize,
                        fontFamily: config.fontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Stepper Controls (+ / -) & Slider
                Row(
                  children: [
                    AppActionButton(
                      icon: Icons.remove,
                      onTap: currentSize > 12
                          ? () {
                              setModalState(() {
                                config.fontSize = currentSize - 1;
                              });
                              _update(ref, config);
                            }
                          : null,
                      actionType: ActionType.edit,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.secondaryText,
                          thumbColor: AppColors.textMain,
                          overlayColor: AppColors.secondaryText.withValues(
                            alpha: 0.2,
                          ),
                          trackHeight: 6,
                        ),
                        child: Slider(
                          value: currentSize,
                          min: 12,
                          max: 30,
                          divisions: 18,
                          onChanged: (val) {
                            setModalState(() {
                              config.fontSize = val;
                            });
                            _update(ref, config);
                          },
                        ),
                      ),
                    ),
                    AppActionButton(
                      icon: Icons.add,
                      onTap: currentSize < 30
                          ? () {
                              setModalState(() {
                                config.fontSize = currentSize + 1;
                              });
                              _update(ref, config);
                            }
                          : null,
                      actionType: ActionType.edit,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              AppButton(
                label: "Xác nhận",
                variant: ButtonVariant.brand,
                size: ButtonSize.small,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔥 CUSTOM FONT PICKER DIALOG (Tối ưu với AppAlertDialog)
  void _showFontPicker(BuildContext context, WidgetRef ref, AppConfig config) {
    showDialog(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: "Chọn Font Chữ",
        size: AlertDialogSize.small,
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: AppStrings.fonts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final font = AppStrings.fonts[index];
              final isSelected = config.fontFamily == font;

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: isSelected
                    ? AppColors.textMain.withValues(alpha: 0.1)
                    : Colors.transparent,
                title: Text(
                  font,
                  style: TextStyle(
                    fontFamily: font,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.textMain
                        : AppColors.secondaryText,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.textMain,
                      )
                    : null,
                onTap: () {
                  config.fontFamily = font;
                  _update(ref, config);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showBindingDialog(
    BuildContext context,
    WidgetRef ref,
    AppConfig config,
    ShortcutAction action,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: "Gán phím: ${action.label}",
        size: AlertDialogSize.small,
        content: Listener(
          onPointerDown: (e) => _handleInput(ctx, ref, config, action, e),
          child: KeyboardListener(
            focusNode: FocusNode()..requestFocus(),
            onKeyEvent: (e) => _handleInput(ctx, ref, config, action, e),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.textMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.textMain.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.keyboard_alt_outlined,
                  size: 48,
                  color: AppColors.textMain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleInput(
    BuildContext ctx,
    WidgetRef ref,
    AppConfig config,
    ShortcutAction action,
    dynamic event,
  ) {
    PhysicalKey? picked;
    if (event is KeyDownEvent) {
      picked = KeyMaps.logicalToPhysical[event.logicalKey];
    }
    if (event is PointerDownEvent) {
      picked = KeyMaps.mouseButtonsMap[event.buttons];
    }

    if (picked != null) {
      final currentMap = Map<ShortcutAction, List<PhysicalKey>>.from(
        config.keyBindings,
      );
      final keys = List<PhysicalKey>.from(currentMap[action] ?? []);
      if (!keys.contains(picked)) {
        keys.add(picked);
        currentMap[action] = keys;
        config.keyBindings = currentMap;
        _update(ref, config);
      }
      Navigator.pop(ctx);
    }
  }

  void _showResetConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppAlertDialog(
        title: "⚠️ Xác nhận Reset",
        size: AlertDialogSize.small,
        content: const Text(
          "Toàn bộ dữ liệu sẽ bị xóa. Ứng dụng cần được đóng lại để làm mới hoàn toàn cấu trúc dữ liệu.",
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          AppButton(
            label: "Xóa & Thoát App",
            variant: ButtonVariant.danger,
            size: ButtonSize.small,
            onPressed: () async {
              await ProviderScope.containerOf(
                ref.context,
              ).read(appConfigProvider.notifier).clearStudyData();

              if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
                exit(0);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => const SliverPadding(
    padding: EdgeInsets.fromLTRB(25, 60, 25, 20),
    sliver: SliverToBoxAdapter(
      child: Text(
        "Cài đặt",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
      ),
    ),
  );

  Widget _buildSectionTitle(String title) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(30, 25, 25, 10),
    sliver: SliverToBoxAdapter(
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryText,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );

  void _showDonateDialog(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final qrHeight = (screenHeight * 0.5).clamp(320.0, 480.0);

    showDialog(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: "Mời mình một cốc cafe ☕",
        size: AlertDialogSize.small,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Quét mã QR để ủng hộ tác giả nhé!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/qr_donate.png',
                  height: qrHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => SizedBox(
                    height: 200,
                    child: Icon(
                      Icons.qr_code_2,
                      size: 120,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings.authorName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
