/* -------------This file is hold all Packages, Path of file -------------*/
export 'dart:async';
export 'dart:convert';
export 'dart:io' show Platform;
export 'dart:io';
export 'dart:typed_data';

export 'package:async/async.dart';

/* Package from Pub.dev */
export 'package:web3dart/web3dart.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter/rendering.dart';
export 'package:flutter/services.dart';
export 'package:line_awesome_flutter/line_awesome_flutter.dart';
export 'package:local_auth/local_auth.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:qr_flutter/qr_flutter.dart';
export 'package:provider/provider.dart';
export 'package:iconsax/iconsax.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:transition/transition.dart';
export 'package:responsive_sizer/responsive_sizer.dart';
export 'package:shimmer/shimmer.dart';
export 'package:polkawallet_sdk/storage/types/keyPairData.dart';
export 'package:wallet_connect/wallet_connect.dart';

/* Component File */
export 'package:wallet_apps/src/components/component.dart';
export 'package:wallet_apps/src/components/dimissible_background.dart';
export 'package:wallet_apps/src/components/home_c.dart';
export 'package:wallet_apps/src/components/menu_c.dart';
export 'package:wallet_apps/src/components/my_input.dart';
export 'package:wallet_apps/src/components/platform_specific/android_native.dart';
export 'package:wallet_apps/src/components/platform_specific/ios_native.dart';
export 'package:wallet_apps/src/components/receive_wallet_c.dart';
export 'package:wallet_apps/src/components/reuse_widget.dart';
export 'package:wallet_apps/src/components/route_animation.dart';
export 'package:wallet_apps/src/components/trx_option_c.dart';
export 'package:wallet_apps/src/config/.app_config.dart';
export 'package:wallet_apps/src/config/size_config.dart';
export 'package:wallet_apps/src/components/portfolio_cus.dart';
export 'package:wallet_apps/src/components/pincode/passcode.dart';
export 'package:wallet_apps/src/components/appbar/appbar_c.dart';
export 'package:wallet_apps/src/components/dialog_c.dart';
export 'package:wallet_apps/src/components/nft/nft_card_c.dart';
export 'package:wallet_apps/src/components/nft/nft_image_animation.dart';

// Add Asset
export 'package:wallet_apps/src/models/asset_m.dart';

export 'package:wallet_apps/src/models/linechart_m.dart';

export 'package:wallet_apps/src/models/crypto_data.dart';

export 'package:wallet_apps/src/utils/fmt.dart';
export 'package:wallet_apps/src/models/home_m.dart';
/* Menu */
export 'package:wallet_apps/src/models/menu_m.dart';

export 'package:wallet_apps/src/models/token.m.dart';
// Dashboard

export 'package:wallet_apps/src/models/smart_contract.m.dart';

export 'package:wallet_apps/src/models/checkin.m.dart';

export 'package:wallet_apps/src/models/model_scan_pay.dart';
/* Main Screen */

export 'package:wallet_apps/src/models/model_user_info.dart';

export 'package:wallet_apps/src/models/tx_history.dart';

/* Home Screen */
export 'package:wallet_apps/src/models/portfolio_m.dart';
export 'package:wallet_apps/src/models/portfolio_rate_m.dart';
// Add Phone

export 'package:wallet_apps/src/route/router.dart';
/* Home Screen */
export 'package:wallet_apps/src/screen/home/menu/account/account.dart';

export 'package:wallet_apps/src/screen/home/claim_airdrop/claim_airdrop.dart';
export 'package:wallet_apps/src/screen/home/claim_airdrop/invite_friend.dart';
// Add Assets
export 'package:wallet_apps/src/screen/home/menu/add_asset/add_asset.dart';
export 'package:wallet_apps/src/screen/home/menu/add_asset/body_add_asset.dart';

/* Menu Screen */
export 'package:wallet_apps/src/screen/home/menu/menu.dart';
export 'package:wallet_apps/src/screen/home/menu/menu_body.dart';
export 'package:wallet_apps/src/screen/home/menu/swap/des_swap.dart';

export 'package:wallet_apps/src/screen/home/menu/about.dart';
export 'package:wallet_apps/src/screen/home/menu/swap/swap.dart';

//Transaction confirmation
export 'package:wallet_apps/src/models/trx_info.dart';

// Transaction Activiity
export 'package:wallet_apps/src/screen/home/menu/trx_activity/reuse_activity_widget.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/body_trx_activity.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity_details/transaction_activity_details.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity_details/body_transaction_activity_details.dart';
// Transaction History
export 'package:wallet_apps/src/screen/home/menu/trx_history/tab_bars_list/all_trx.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/tab_bars_list/received_trx.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/tab_bars_list/send_transaction.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/body_trx_history.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history_details/trx_history_detail.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history_details/body_trx_history_detail.dart';
export 'package:wallet_apps/src/screen/home/receive_wallet/receive_wallet.dart';
export 'package:wallet_apps/src/screen/home/receive_wallet/body_receive_wallet.dart';
export 'package:wallet_apps/src/screen/home/transaction/qr_scanner/qr_scanner.dart';
export 'package:wallet_apps/src/components/fill_pin_dialog.dart';
export 'package:wallet_apps/src/screen/home/transaction/submit_trx/submit_trx.dart';
export 'package:wallet_apps/src/screen/home/transaction/submit_trx/body_submit_trx.dart';
export 'package:wallet_apps/src/screen/home/transaction/confirmation/confimation_tx.dart';
export 'package:wallet_apps/src/screen/auth/seeds/import_seeds/import_acc.dart';
export 'package:wallet_apps/src/screen/auth/authentication.dart';
// Finger Print
export 'package:wallet_apps/src/screen/auth/splash_screen.dart';

export 'package:wallet_apps/src/screen/auth/seeds/import_seeds/body_import_acc.dart';
// Main Screeen
export 'package:wallet_apps/src/screen/auth/onboarding/onboarding.dart';
export 'package:wallet_apps/src/screen/auth/onboarding/body_onboarding.dart';

export 'package:wallet_apps/src/screen/home/contact_book/contact_book.dart';

/* Local File */
export 'package:wallet_apps/src/service/services.dart';
//Service
export 'package:wallet_apps/src/service/storage.dart';
export 'package:wallet_apps/src/utils/app_utils.dart';
/* ---------------------Util------------------------ */
export 'package:wallet_apps/theme/color.dart';
export 'package:wallet_apps/theme/string.dart';
export 'package:wallet_apps/theme/style.dart';

//Provider
export 'src/provider/api_p.dart';
export 'src/provider/contract_p.dart';
export 'src/provider/wallet_p.dart';
export 'src/provider/market_p.dart';
export 'src/provider/theme_p.dart';
export 'package:wallet_apps/src/provider/app_p.dart';
export 'package:wallet_apps/src/provider/dsc_p.dart';

// Asset Info
export 'src/screen/home/asset_info/asset_checkin.dart';
export 'src/screen/home/asset_info/asset_history.dart';
export 'src/screen/home/asset_info/asset_info.dart';
export 'package:wallet_apps/theme/global.dart';

