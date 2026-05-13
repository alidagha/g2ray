# g2ray

A self-hosted proxy setup that runs inside GitHub Codespaces.

## Quick Start

1. Fork this repository to your own account
2. Navigate to your fork and open the **Codespaces** tab under the Code button
3. Create a new codespace on the main branch
4. Wait a few minutes for the environment to build and initialize
5. Your connection string will appear in the terminal once setup is complete

## Connecting

Grab the link printed in the terminal and paste it into any compatible client (v2rayNG, Nekobox, etc.).

## Usage Limits

GitHub Codespaces provides **120 core-hours/month** on the free tier. Since this config uses 2 cores, that translates to roughly 60 hours per month. Make sure to stop your codespace when not actively using it to avoid burning through your quota.

## Compatibility

Works on most networks that aren't aggressively blocking GitHub infrastructure. If the default region doesn't work for you, try creating the codespace in a different datacenter.

## Disclaimer

This project is strictly experimental and intended for **educational and research purposes only**. It does not violate GitHub's Terms of Service. It uses GitHub Codespaces — a feature officially provided by GitHub — in its intended manner. No abuse, exploit, or unauthorized access is involved.

Users are solely responsible for how they use this software and must comply with all applicable local laws and regulations. The authors assume no liability for any misuse.

## License

MIT License — see [LICENSE](LICENSE) for details.
