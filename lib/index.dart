// Core Flutter
export 'package:flutter/material.dart';
export 'dart:io';
export 'package:flutter/services.dart';
export 'package:flutter/foundation.dart';
export 'dart:convert';
export 'package:dropdown_button2/dropdown_button2.dart';
export 'package:flutter/rendering.dart';

// Pub & Packages
export 'package:bitriel_wallet/app.dart';
export 'package:flutter_dotenv/flutter_dotenv.dart';
export 'package:path_provider/path_provider.dart';
export 'package:local_auth/local_auth.dart';
export 'package:web3dart/web3dart.dart';
export 'package:web_socket_channel/io.dart';
export 'package:ua_client_hints/ua_client_hints.dart';
export 'package:random_avatar/random_avatar.dart';
export 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
export 'package:quickalert/quickalert.dart';
export 'package:qr_flutter/qr_flutter.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:shimmer/shimmer.dart';

// ignore: depend_on_referenced_packages
export 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
export 'package:http/http.dart';
export 'package:provider/provider.dart';
export 'package:iconsax/iconsax.dart';
export 'package:lottie/lottie.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:fl_chart/fl_chart.dart';
export 'package:unicons/unicons.dart';
export 'package:sticky_grouped_list/sticky_grouped_list.dart';

// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/apiKeyring.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/storage/types/keyPairData.dart';
// ignore: depend_on_referenced_packages
export 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/utils/index.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/types/txInfoData.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/apiTx.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/service/tx.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/api.dart';

export 'package:bitriel_wallet/data/storage.dart';

export 'package:share_plus/share_plus.dart';
export 'package:qr_code_scanner/qr_code_scanner.dart';

export 'package:easy_debounce/easy_debounce.dart';

/*---------- Data Layer ----------*/

/// SDK
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/polkawallet_sdk.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/storage/keyring.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/types/networkParams.dart';
export 'package:bitriel_wallet/data/sdk/bitriel_sdk.dart';
export 'package:bitriel_wallet/data/sdk/web3.dart';
export 'package:bitriel_wallet/data/api/api_client.dart';
export 'package:bitriel_wallet/data/api/get_api.dart';

// Repository
export 'package:bitriel_wallet/data/repository/asset_repo/asset_repo.dart';
export 'package:bitriel_wallet/data/repository/asset_repo/asset_repo_impl.dart';
export 'package:bitriel_wallet/data/repository/sdk_repo/sdk_repo_impl.dart';
export 'package:bitriel_wallet/data/repository/sdk_repo/web3_rep.dart';
export 'package:bitriel_wallet/data/repository/sdk_repo/web3_impl.dart';
export 'package:bitriel_wallet/data/repository/http_request_repo/http_request_impl.dart';
export 'package:bitriel_wallet/data/repository/market_repo/market_repo.dart';
export 'package:bitriel_wallet/data/repository/market_repo/market_repo_impl.dart';
export 'package:bitriel_wallet/data/repository/lets_ex_repo/lets_ex_repo.dart';
export 'package:bitriel_wallet/data/repository/lets_ex_repo/lets_ex_repo_impl.dart';
export 'package:bitriel_wallet/domain/usecases/swap_uc/lets_exchange_uc/lets_ex_uc_impl.dart';

/*---------- Domain Layer ----------*/

export 'package:bitriel_wallet/domain/validator/validator.dart';
// Model
export 'package:bitriel_wallet/domain/model/pin_m.dart';
export 'package:bitriel_wallet/domain/model/create_acc_m.dart';
export 'package:bitriel_wallet/domain/model/new_acc_m.dart';
export 'package:bitriel_wallet/domain/model/smart_contract_m.dart';
export 'package:bitriel_wallet/domain/model/line_chart_model.dart';
export 'package:bitriel_wallet/domain/model/market.m.dart';
export 'package:bitriel_wallet/domain/model/exchange.model/lets_ex_coin_m.dart';
export 'package:bitriel_wallet/domain/model/swap_m.dart';
export 'package:bitriel_wallet/domain/model/coin_info_m.dart';

// Usecases
export 'package:bitriel_wallet/domain/usecases/asset_uc/asset_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/pin_uc/pin_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/asset_uc/asset_uc.dart';
export 'package:bitriel_wallet/domain/usecases/sdk_uc/sdk_uc.dart';
export 'package:bitriel_wallet/domain/usecases/sdk_uc/sdk_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/pin_uc/pin_uc.dart';
export 'package:bitriel_wallet/domain/usecases/secure_storage_uc/secure_storage_uc.dart';
export 'package:bitriel_wallet/domain/usecases/secure_storage_uc/secure_storage_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/acc_manage_uc.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/acc_manage_impl.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/create_wallet/create_wallet_uc.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/create_wallet/create_wallet_impl.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/import_wallet/import_wallet_uc.dart';
export 'package:bitriel_wallet/domain/usecases/app_uc/app_uc.dart';
export 'package:bitriel_wallet/domain/usecases/app_uc/app_impl.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/multi_acc/multi_acc_uc.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/multi_acc/multi_acc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/wallet_uc/wallet_uc.dart';
export 'package:bitriel_wallet/domain/usecases/wallet_uc/wallet_impl.dart';
export 'package:bitriel_wallet/domain/usecases/market_uc/market_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/market_uc/market_uc.dart';
export 'package:bitriel_wallet/domain/usecases/navbar/navbar_uc.dart';
export 'package:bitriel_wallet/domain/usecases/navbar/navbar_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/add_asset_uc/add_asset_uc.dart';
export 'package:bitriel_wallet/domain/usecases/add_asset_uc/add_asset_impl.dart';
export 'package:bitriel_wallet/domain/usecases/payment_uc/payment_us.dart';
export 'package:bitriel_wallet/domain/usecases/payment_uc/payment_impl.dart';
export 'package:bitriel_wallet/domain/usecases/swap_uc/lets_exchange_uc/lets_ex_uc.dart';
export 'package:bitriel_wallet/domain/usecases/wallet_uc/receive_uc.dart';
export 'package:bitriel_wallet/domain/usecases/scan_qr_uc/scan_qr_uc.dart';
export 'package:bitriel_wallet/domain/usecases/scan_qr_uc/scan_qr_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/home_uc/home.usecase.dart';
export 'package:bitriel_wallet/domain/usecases/swap_uc/exolix_uc/exolix_ex_uc_impl.dart';

/*---------- Presentation Layer ----------*/

// Screen
export 'package:bitriel_wallet/presentation/screen/welcome_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/create_seed_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/import_wallet_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/verify_seed_screen.dart';
export 'package:bitriel_wallet/presentation/screen/pin_screen.dart';
export 'package:bitriel_wallet/presentation/screen/home_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/multi_acc_screen.dart';
export 'package:bitriel_wallet/presentation/screen/setting_screen.dart';
export 'package:bitriel_wallet/presentation/screen/wallet/wallet_screen.dart';
export 'package:bitriel_wallet/presentation/screen/token_info_screen.dart';
export 'package:bitriel_wallet/presentation/screen/wallet/add_asset_screen.dart';
export 'package:bitriel_wallet/presentation/screen/wallet/payment/payment_screen.dart';
export 'package:bitriel_wallet/presentation/screen/wallet/receive_screen.dart';
export 'package:bitriel_wallet/presentation/screen/wallet/transaction_detail_screen.dart';
export 'package:bitriel_wallet/presentation/screen/exchange/coin_selection.dart';
export 'package:bitriel_wallet/presentation/screen/about_screen.dart';
export 'package:bitriel_wallet/presentation/screen/privacy_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/backup_wallet_screen.dart';
export 'package:bitriel_wallet/presentation/screen/qr_scanner/qr_scanner_screen.dart';

// Widget
export 'package:bitriel_wallet/presentation/widget/text_widget.dart';
export 'package:bitriel_wallet/presentation/widget/account/seed_widget.dart';
export 'package:bitriel_wallet/presentation/widget/textformfield_wg.dart';
export 'package:bitriel_wallet/presentation/widget/button_widget.dart';
export 'package:bitriel_wallet/presentation/widget/pin_widget.dart';
export 'package:bitriel_wallet/presentation/widget/dialog_widget.dart';
export 'package:bitriel_wallet/presentation/widget/btn_widget.dart';
export 'package:bitriel_wallet/presentation/widget/dashboard_menu_items.dart';
export 'package:bitriel_wallet/presentation/widget/acc_item_c.dart';
export 'package:bitriel_wallet/presentation/widget/appbar_widget.dart';
export 'package:bitriel_wallet/presentation/widget/wallet/asset_item_widget.dart';
export 'package:bitriel_wallet/presentation/widget/wallet/wallet_widget.dart';
export 'package:bitriel_wallet/presentation/widget/text_c.dart';
export 'package:bitriel_wallet/presentation/widget/shimmer_market_widget.dart';
export 'package:bitriel_wallet/presentation/widget/dropdown_widget.dart';
export 'package:bitriel_wallet/presentation/widget/swap_numpad_c.dart';
export 'package:bitriel_wallet/presentation/screen/main_screen.dart';
export 'package:bitriel_wallet/presentation/screen/exchange/swap.dart';

// Provider
export 'package:bitriel_wallet/presentation/provider/asset_pro.dart';
export 'package:bitriel_wallet/presentation/provider/sdk_pro.dart';
export 'package:bitriel_wallet/presentation/provider/wallet_pro.dart';

/*---------- Standalone Layer ----------*/
export 'package:bitriel_wallet/standalone/utils/routes/router.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/app_utils.dart';
export 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
export 'package:bitriel_wallet/standalone/core/db_key_con.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/fmt.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/icon_path_util.dart';

// Application Layer
export 'package:bitriel_wallet/application/helper/helper.dart';
