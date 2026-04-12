import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_strings.dart';
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

  // Cơ chế Container an toàn để tránh lỗi disposed
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
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
                          color: Colors.blue,
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
                    SettingSwitchTile(
                      icon: Icons.bolt_rounded,
                      title: "Phím tắt nhanh (A-Z)",
                      subtitle: "Chọn đáp án ngay lập tức",
                      value: config.enableQuickAnswer,
                      onChanged: (val) {
                        config.enableQuickAnswer = val;
                        _update(ref, config);
                      },
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
                      iconColor: Colors.red,
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

  void _showBindingDialog(
    BuildContext context,
    WidgetRef ref,
    AppConfig config,
    ShortcutAction action,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Gán phím: ${action.label}"),
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
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.keyboard_alt_outlined,
                  size: 48,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              enabledMouseCursor: SystemMouseCursors.click,
            ),
            child: const Text("Đóng"),
          ),
        ],
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

  void _showFontSizePicker(
    BuildContext context,
    WidgetRef ref,
    AppConfig config,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(30),
          height: 180,
          child: Column(
            children: [
              Text(
                "Kích thước: ${config.fontSize.toInt()}px",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                mouseCursor: SystemMouseCursors.click,
                value: config.fontSize,
                min: 12,
                max: 30,
                divisions: 18,
                onChanged: (val) {
                  setModalState(() => config.fontSize = val);
                  _update(ref, config);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontPicker(BuildContext context, WidgetRef ref, AppConfig config) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: AppStrings.fonts
            .map(
              (f) => ListTile(
                mouseCursor: SystemMouseCursors.click,
                title: Text(f, style: TextStyle(fontFamily: f)),
                onTap: () {
                  config.fontFamily = f;
                  _update(ref, config);
                  Navigator.pop(ctx);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showResetConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text("Xác nhận Reset"),
          ],
        ),
        content: const Text(
          "Toàn bộ dữ liệu sẽ bị xóa. Ứng dụng cần được đóng lại để làm mới hoàn toàn cấu trúc dữ liệu.",
        ),
        actions: [
          TextButton(
            // Thêm style để có Mouse Cursor
            style: TextButton.styleFrom(
              enabledMouseCursor: SystemMouseCursors.click,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              // Thêm style để có Mouse Cursor
              enabledMouseCursor: SystemMouseCursors.click,
            ),
            onPressed: () async {
              // 1. Thực hiện xoá dưới DB
              await ProviderScope.containerOf(
                ref.context,
              ).read(appConfigProvider.notifier).clearStudyData();

              // 2. Thoát App
              if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
                exit(0); // Lệnh thoát mạnh mẽ cho Desktop
              } else {
                SystemNavigator.pop(); // Dành cho Mobile
              }
            },
            child: const Text("Xóa & Thoát App"),
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
          color: Colors.blueGrey,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );

  void _showDonateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Mời mình một cốc cafe ☕"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Quét mã QR để ủng hộ tác giả nhé!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/qr_donate.png',
                width: 600,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.qr_code_2, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              AppStrings.authorName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }
}
