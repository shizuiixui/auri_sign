import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Certified Alphabet Signer Badge
class AlphabetBadge extends StatelessWidget {
  const AlphabetBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
    <svg viewBox="80 50 240 270" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(200,190)">
        <g fill="#93C5FD">
          <circle cx="0" cy="-108" r="20"/><circle cx="42" cy="-96" r="20"/><circle cx="76" cy="-68" r="20"/>
          <circle cx="98" cy="-30" r="20"/><circle cx="98" cy="30" r="20"/><circle cx="76" cy="68" r="20"/>
          <circle cx="42" cy="96" r="20"/><circle cx="0" cy="108" r="20"/><circle cx="-42" cy="96" r="20"/>
          <circle cx="-76" cy="68" r="20"/><circle cx="-98" cy="30" r="20"/><circle cx="-98" cy="-30" r="20"/>
          <circle cx="-76" cy="-68" r="20"/><circle cx="-42" cy="-96" r="20"/>
        </g>
        <circle r="100" fill="#1D4ED8" stroke="#1E40AF" stroke-width="4"/>
        <circle r="86" fill="#3B82F6"/>
        <path d="M-30,-20 L0,-55 L30,-20 L30,45 L-30,45 Z" fill="#FEF08A" stroke="#CA8A04" stroke-width="4" stroke-linejoin="round"/>
        <text x="0" y="26" text-anchor="middle" font-size="62" font-weight="900" fill="#1E40AF" font-family="Arial, sans-serif">A</text>
        <path d="M-84,-66 l4,9 l9,4 l-9,4 l-4,9 l-4,-9 l-9,-4 l9,-4 Z" fill="#FFFFFF"/>
        <circle cx="76" cy="56" r="4" fill="#FFFFFF"/>
      </g>
      <g transform="translate(200,84)">
        <circle r="28" fill="#FFFFFF" stroke="#1D4ED8" stroke-width="4"/>
        <text x="0" y="10" text-anchor="middle" font-size="22" font-weight="700" fill="#1D4ED8" font-family="Arial, sans-serif">ASL</text>
      </g>
    </svg>
    ''';

    return SvgPicture.string(svgString, fit: BoxFit.contain);
  }
}

// Certified Numeric Signer Badge
class NumberBadge extends StatelessWidget {
  const NumberBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
    <svg viewBox="80 50 240 270" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(200,190)">
        <g fill="#A7F3D0">
          <circle cx="0" cy="-108" r="20"/><circle cx="42" cy="-96" r="20"/><circle cx="76" cy="-68" r="20"/>
          <circle cx="98" cy="-30" r="20"/><circle cx="98" cy="30" r="20"/><circle cx="76" cy="68" r="20"/>
          <circle cx="42" cy="96" r="20"/><circle cx="0" cy="108" r="20"/><circle cx="-42" cy="96" r="20"/>
          <circle cx="-76" cy="68" r="20"/><circle cx="-98" cy="30" r="20"/><circle cx="-98" cy="-30" r="20"/>
          <circle cx="-76" cy="-68" r="20"/><circle cx="-42" cy="-96" r="20"/>
        </g>
        <circle r="100" fill="#047857" stroke="#065F46" stroke-width="4"/>
        <circle r="86" fill="#10B981"/>
        <path d="M-35,-20 L0,-55 L35,-20 L35,45 L-35,45 Z" fill="#FEF08A" stroke="#CA8A04" stroke-width="4" stroke-linejoin="round"/>
        <text x="0" y="25" text-anchor="middle" font-size="46" font-weight="900" fill="#047857" font-family="Arial, sans-serif">123</text>
        <path d="M-84,-66 l4,9 l9,4 l-9,4 l-4,9 l-4,-9 l-9,-4 l9,-4 Z" fill="#FFFFFF"/>
        <circle cx="76" cy="56" r="4" fill="#FFFFFF"/>
      </g>
      <g transform="translate(200,84)">
        <circle r="28" fill="#FFFFFF" stroke="#047857" stroke-width="4"/>
        <text x="0" y="10" text-anchor="middle" font-size="22" font-weight="700" fill="#047857" font-family="Arial, sans-serif">123</text>
      </g>
    </svg>
    ''';

    return SvgPicture.string(svgString, fit: BoxFit.contain);
  }
}

// Certified Phrase Communicator Badge
class PhraseBadge extends StatelessWidget {
  const PhraseBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
    <svg viewBox="80 50 240 270" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(200,190)">
        <g fill="#FBCFE8">
          <circle cx="0" cy="-108" r="20"/><circle cx="42" cy="-96" r="20"/><circle cx="76" cy="-68" r="20"/>
          <circle cx="98" cy="-30" r="20"/><circle cx="98" cy="30" r="20"/><circle cx="76" cy="68" r="20"/>
          <circle cx="42" cy="96" r="20"/><circle cx="0" cy="108" r="20"/><circle cx="-42" cy="96" r="20"/>
          <circle cx="-76" cy="68" r="20"/><circle cx="-98" cy="30" r="20"/><circle cx="-98" cy="-30" r="20"/>
          <circle cx="-76" cy="-68" r="20"/><circle cx="-42" cy="-96" r="20"/>
        </g>
        <circle r="100" fill="#BE185D" stroke="#9D174D" stroke-width="4"/>
        <circle r="86" fill="#EC4899"/>
        <path d="M0,42 C-42,15 -52,-22 -24,-42 C-4,-42 0,-20 0,-18 C0,-20 4,-42 24,-42 C52,-22 42,15 0,42 Z" fill="#FEF08A" stroke="#CA8A04" stroke-width="4"/>
        <path d="M-84,-66 l4,9 l9,4 l-9,4 l-4,9 l-4,-9 l-9,-4 l9,-4 Z" fill="#FFFFFF"/>
        <circle cx="76" cy="56" r="4" fill="#FFFFFF"/>
      </g>
      <g transform="translate(200,84)">
        <circle r="28" fill="#FFFFFF" stroke="#BE185D" stroke-width="4"/>
        <text x="0" y="12" text-anchor="middle" font-size="26" fill="#BE185D">♥</text>
      </g>
    </svg>
    ''';
    return SvgPicture.string(svgString, fit: BoxFit.contain);
  }
}

// First Steps Platform Milestone Badge (Matching Web)
class FirstStepsBadge extends StatelessWidget {
  const FirstStepsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
    <svg viewBox="80 50 240 270" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(200,185)">
        <!-- Outer Lime Green Petals -->
        <g fill="#A3E635">
          <circle cx="0" cy="-108" r="20"/><circle cx="42" cy="-96" r="20"/><circle cx="76" cy="-68" r="20"/>
          <circle cx="98" cy="-30" r="20"/><circle cx="98" cy="30" r="20"/><circle cx="76" cy="68" r="20"/>
          <circle cx="42" cy="96" r="20"/><circle cx="0" cy="108" r="20"/><circle cx="-42" cy="96" r="20"/>
          <circle cx="-76" cy="68" r="20"/><circle cx="-98" cy="30" r="20"/><circle cx="-98" cy="-30" r="20"/>
          <circle cx="-76" cy="-68" r="20"/><circle cx="-42" cy="-96" r="20"/>
        </g>
        <!-- Dark Green Ring -->
        <circle r="100" fill="#4D7C0F" stroke="#365314" stroke-width="4"/>
        <!-- Inner Lime Circle -->
        <circle r="86" fill="#84CC16"/>
        <!-- House/Pentagon Emblem -->
        <path d="M-30,-20 L0,-55 L30,-20 L30,45 L-30,45 Z" fill="#FEF08A" stroke="#CA8A04" stroke-width="4" stroke-linejoin="round"/>
        <!-- Number 1 -->
        <text x="0" y="27" text-anchor="middle" font-size="58" font-weight="900" fill="#B45309" font-family="Arial, sans-serif">1</text>
        <!-- Sparkle & Shine -->
        <path d="M-84,-66 l4,9 l9,4 l-9,4 l-4,9 l-4,-9 l-9,-4 l9,-4 Z" fill="#FFFFFF"/>
        <circle cx="76" cy="56" r="4" fill="#FFFFFF"/>
      </g>
    </svg>
    ''';
    return SvgPicture.string(svgString, fit: BoxFit.contain);
  }
}

// Sign Language Master Platform Milestone Badge (Matching Web)
class MasterBadge extends StatelessWidget {
  const MasterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
    <svg viewBox="80 50 240 270" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(200,190)">
        <!-- Outer Gold/Yellow Petals -->
        <g fill="#FDE68A">
          <circle cx="0" cy="-108" r="20"/><circle cx="42" cy="-96" r="20"/><circle cx="76" cy="-68" r="20"/>
          <circle cx="98" cy="-30" r="20"/><circle cx="98" cy="30" r="20"/><circle cx="76" cy="68" r="20"/>
          <circle cx="42" cy="96" r="20"/><circle cx="0" cy="108" r="20"/><circle cx="-42" cy="96" r="20"/>
          <circle cx="-76" cy="68" r="20"/><circle cx="-98" cy="30" r="20"/><circle cx="-98" cy="-30" r="20"/>
          <circle cx="-76" cy="-68" r="20"/><circle cx="-42" cy="-96" r="20"/>
        </g>
        <!-- Deep Purple Ring -->
        <circle r="100" fill="#581C87" stroke="#4C1D95" stroke-width="4"/>
        <!-- Inner Violet Circle -->
        <circle r="86" fill="#7C3AED"/>
        <!-- 3-Peak Golden Crown -->
        <path d="M-36,22 L36,22 L32,-12 L16,3 L0,-34 L-16,3 L-32,-12 Z" fill="#FEF08A" stroke="#CA8A04" stroke-width="4" stroke-linejoin="round"/>
        <!-- Sparkle & Shine -->
        <path d="M-84,-66 l4,9 l9,4 l-9,4 l-4,9 l-4,-9 l-9,-4 l9,-4 Z" fill="#FFFFFF"/>
        <circle cx="76" cy="56" r="4" fill="#FFFFFF"/>
      </g>
      <!-- Top Circular Crest -->
      <g transform="translate(200,84)">
        <circle r="28" fill="#FFFFFF" stroke="#CA8A04" stroke-width="4"/>
        <!-- Mini Crown with Jewels -->
        <path d="M-13,8 L13,8 L12,-4 L6,2 L0,-8 L-6,2 L-12,-4 Z" fill="#FBBF24" stroke="#B45309" stroke-width="1.5" stroke-linejoin="round"/>
        <circle cx="-6" cy="3.5" r="1.5" fill="#EF4444"/>
        <circle cx="0" cy="3.5" r="1.8" fill="#3B82F6"/>
        <circle cx="6" cy="3.5" r="1.5" fill="#10B981"/>
      </g>
    </svg>
    ''';
    return SvgPicture.string(svgString, fit: BoxFit.contain);
  }
}
