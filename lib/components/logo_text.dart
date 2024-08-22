import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiittime/theme/extensions.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0,top: 3),
          child: SvgPicture.asset(
            'lib/assets/logo.svg',
            width: 32,
            colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn),
                fit: BoxFit.cover,
          ),
        ),
        Text(
          "IITTIME",
          style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: context.colorScheme.primary),
        ),
      ],
    );
  }
}
