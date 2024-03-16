# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@e7851264332cc37999853075275cb39cc7ffa227/icons/zerotier-one.png" width="48" height="48"/> [zerotier-one](https://community.chocolatey.org/packages/zerotier-one)

## ZeroTier - Global Area Networking

ZeroTier is a smart programmable Ethernet switch for planet Earth. It allows networked devices and applications to be managed as if the entire world is one data center or cloud region.

It replaces the physical LAN/WAN boundary with a virtual one, allowing devices of any type at any location to be managed as if they all reside in the same cloud region or data center. All traffic is encrypted end-to-end and takes the most direct path available for minimum latency and maximum performance. The goals and design of ZeroTier are inspired by among other things the original [Google BeyondCorp](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43231.pdf) paper and the [Jericho Forum](https://en.wikipedia.org/wiki/Jericho_Forum).

Visit [ZeroTier's site](https://www.zerotier.com/) for more information and [pre-built binary packages](https://www.zerotier.com/download/). Apps for Android and iOS are available for free in the Google Play and Apple app stores.

### Getting Started

Everything in the ZeroTier world is controlled by two types of identifier: 40-bit/10-digit *ZeroTier addresses* and 64-bit/16-digit *network IDs*. A ZeroTier address identifies a node or "device" (laptop, phone, server, VM, app, etc.) while a network ID identifies a virtual Ethernet network that can be joined by devices.

Another way of thinking about it is that ZeroTier addresses are port numbers on a giant planetary-sized smart switch while network IDs are VLANs to which these ports can be assigned. For more details read about VL1 and VL2 in [the ZeroTier manual](https://www.zerotier.com/manual/).
ZeroTier is a smart switch for Earth with VLAN capability. See [https://www.zerotier.com/](https://www.zerotier.com/) for more information.

*Network controllers* are ZeroTier nodes that act as access control certificate authorities and configuration managers for virtual networks. The first 40 bits (or 10 digits) of a network ID is the ZeroTier address of its controller. You can create networks with our [hosted controllers](https://my.zerotier.com/) and web UI/API or [host your own](https://github.com/zerotier/ZeroTierOne/blob/master/controller/) if you don't mind posting some JSON configuration info or writing a script to do so.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.
