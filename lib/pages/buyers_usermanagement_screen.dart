import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ── Data model ────────────────────────────────────────────────────────────────
class _UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String joined;
  final int orders;
  final double totalSpent;
  final Color roleColor;
  final String initials;
  final Color avatarColor;

  const _UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joined,
    required this.orders,
    required this.totalSpent,
    required this.roleColor,
    required this.initials,
    required this.avatarColor,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery  = '';
  String _filterRole   = 'All';
  String _filterStatus = 'All';
  int?   _selectedUser;

  final List<String> _roleFilters   = ['All', 'Admin', 'Seller', 'Buyer', 'Premium'];
  final List<String> _statusFilters = ['All', 'Active', 'Inactive', 'Suspended'];

  final List<_UserModel> _users = const [
    _UserModel(
      id: 'USR-001', name: 'Systrom A.', email: 'gbennerth@gmail.com',
      role: 'Admin', status: 'Active', joined: 'Jan 2024',
      orders: 0, totalSpent: 0.0,
      roleColor: Color(0xFF8B5CF6), initials: 'SA',
      avatarColor: Color(0xFF7C3AED),
    ),
    _UserModel(
      id: 'USR-002', name: 'Ama Owusu', email: 'ama.owusu@gmail.com',
      role: 'Premium', status: 'Active', joined: 'Mar 2024',
      orders: 24, totalSpent: 1240.50,
      roleColor: Color(0xFFF59E0B), initials: 'AO',
      avatarColor: Color(0xFFD97706),
    ),
    _UserModel(
      id: 'USR-003', name: 'Kwame Mensah', email: 'kmensah@yahoo.com',
      role: 'Seller', status: 'Active', joined: 'Feb 2024',
      orders: 5, totalSpent: 320.00,
      roleColor: Color(0xFF059669), initials: 'KM',
      avatarColor: Color(0xFF047857),
    ),
    _UserModel(
      id: 'USR-004', name: 'Abena Darko', email: 'abenadarko@hotmail.com',
      role: 'Buyer', status: 'Inactive', joined: 'Apr 2024',
      orders: 3, totalSpent: 89.99,
      roleColor: Color(0xFF0284C7), initials: 'AD',
      avatarColor: Color(0xFF0369A1),
    ),
    _UserModel(
      id: 'USR-005', name: 'Kofi Asante', email: 'kofi.asante@comfi.gh',
      role: 'Seller', status: 'Active', joined: 'May 2024',
      orders: 12, totalSpent: 560.00,
      roleColor: Color(0xFF059669), initials: 'KA',
      avatarColor: Color(0xFF047857),
    ),
    _UserModel(
      id: 'USR-006', name: 'Efua Boateng', email: 'efua.b@gmail.com',
      role: 'Buyer', status: 'Suspended', joined: 'Jun 2024',
      orders: 1, totalSpent: 15.00,
      roleColor: Color(0xFF0284C7), initials: 'EB',
      avatarColor: Color(0xFFEF4444),
    ),
    _UserModel(
      id: 'USR-007', name: 'Nana Adjei', email: 'nana.adjei@comfi.gh',
      role: 'Premium', status: 'Active', joined: 'Jul 2024',
      orders: 18, totalSpent: 890.20,
      roleColor: Color(0xFFF59E0B), initials: 'NA',
      avatarColor: Color(0xFFB45309),
    ),
  ];

  List<_UserModel> get _filteredUsers {
    return _users.where((u) {
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.id.toLowerCase().contains(q);
      final matchRole   = _filterRole == 'All'   || u.role == _filterRole;
      final matchStatus = _filterStatus == 'All' || u.status == _filterStatus;
      return matchSearch && matchRole && matchStatus;
    }).toList();
  }

  // Stats
  int get _totalUsers  => _users.length;
  int get _activeUsers => _users.where((u) => u.status == 'Active').length;
  int get _sellers     => _users.where((u) => u.role == 'Seller').length;
  int get _premiumUsers=> _users.where((u) => u.role == 'Premium').length;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark        = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg        = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.5) : const Color(0xFF64748B);
    final searchHint    = isDark ? Colors.white.withOpacity(0.3) : const Color(0xFFADB5C7);
    const accent        = Color(0xFF8B5CF6);

    final filtered = _filteredUsers;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: primaryText, size: 16),
          ),
        ),
        title: Text('User Management',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => _showInviteDialog(
              context, isDark, primaryText, surfaceColor, borderColor, secondaryText,
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 5),
                  Text('Invite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── Stats Row ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      _StatCard(value: '$_totalUsers',  label: 'Total',   color: const Color(0xFF8B5CF6), isDark: isDark, cardBg: cardBg, primaryText: primaryText, secondaryText: secondaryText),
                      const SizedBox(width: 10),
                      _StatCard(value: '$_activeUsers', label: 'Active',  color: const Color(0xFF34D399), isDark: isDark, cardBg: cardBg, primaryText: primaryText, secondaryText: secondaryText),
                      const SizedBox(width: 10),
                      _StatCard(value: '$_sellers',     label: 'Sellers', color: const Color(0xFF059669), isDark: isDark, cardBg: cardBg, primaryText: primaryText, secondaryText: secondaryText),
                      const SizedBox(width: 10),
                      _StatCard(value: '$_premiumUsers',label: 'Premium', color: const Color(0xFFF59E0B), isDark: isDark, cardBg: cardBg, primaryText: primaryText, secondaryText: secondaryText),
                    ],
                  ),
                ),
              ),

              // ── Search Bar ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: TextStyle(color: primaryText, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search by name, email or ID...',
                        hintStyle: TextStyle(color: searchHint, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: searchHint, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchCtrl.clear();
                                  setState(() => _searchQuery = '');
                                },
                                child: Icon(Icons.close_rounded,
                                    color: searchHint, size: 18),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Role Filter Chips ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 0, 0),
                  child: SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ..._roleFilters.map((f) => _FilterChip(
                          label: f,
                          isSelected: _filterRole == f,
                          onTap: () => setState(() => _filterRole = f),
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                          borderColor: borderColor,
                        )),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 24,
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          color: borderColor,
                        ),
                        const SizedBox(width: 8),
                        ..._statusFilters.map((f) => _FilterChip(
                          label: f,
                          isSelected: _filterStatus == f,
                          onTap: () => setState(() => _filterStatus = f),
                          color: _statusColor(f),
                          isDark: isDark,
                          borderColor: borderColor,
                        )),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Results count ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filtered.length} user${filtered.length != 1 ? 's' : ''} found',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showSortSheet(
                          context, isDark, primaryText, surfaceColor, borderColor,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.sort_rounded, color: secondaryText, size: 16),
                            const SizedBox(width: 4),
                            Text('Sort',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── User List ──────────────────────────────────────────────
              filtered.isEmpty
                  ? SliverFillRemaining(
                      child: _EmptyState(primaryText: primaryText, secondaryText: secondaryText),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final user = filtered[i];
                            final isExpanded = _selectedUser == i;
                            return _UserCard(
                              user: user,
                              isExpanded: isExpanded,
                              isDark: isDark,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              primaryText: primaryText,
                              secondaryText: secondaryText,
                              onTap: () => setState(() =>
                                  _selectedUser = isExpanded ? null : i),
                              onAction: (action) => _handleUserAction(
                                ctx, action, user, isDark, primaryText,
                                surfaceColor, borderColor,
                              ),
                            );
                          },
                          childCount: filtered.length,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':    return const Color(0xFF34D399);
      case 'Inactive':  return const Color(0xFF94A3B8);
      case 'Suspended': return const Color(0xFFEF4444);
      default:          return const Color(0xFF8B5CF6);
    }
  }

  void _handleUserAction(
    BuildContext ctx,
    String action,
    _UserModel user,
    bool isDark,
    Color primaryText,
    Color surfaceColor,
    Color borderColor,
  ) {
    HapticFeedback.lightImpact();
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // User header
            Row(
              children: [
                _AvatarWidget(user: user, size: 48),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(action,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._userActions(user).map((a) => GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                _showConfirmSnackbar(ctx, isDark, a['label'] as String, user.name);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: (a['color'] as Color).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(a['icon'] as IconData,
                        color: a['color'] as Color, size: 20),
                    const SizedBox(width: 14),
                    Text(a['label'] as String,
                      style: TextStyle(
                        color: a['color'] as Color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _userActions(_UserModel user) {
    final actions = <Map<String, dynamic>>[
      {'icon': LineAwesomeIcons.user_edit_solid, 'label': 'Edit User', 'color': const Color(0xFF8B5CF6)},
      {'icon': LineAwesomeIcons.envelope, 'label': 'Send Email', 'color': const Color(0xFF0284C7)},
      {'icon': LineAwesomeIcons.key_solid, 'label': 'Reset Password', 'color': const Color(0xFFF59E0B)},
    ];
    if (user.status == 'Active') {
      actions.add({'icon': LineAwesomeIcons.pause_circle, 'label': 'Suspend User', 'color': const Color(0xFFEF4444)});
    } else if (user.status == 'Suspended') {
      actions.add({'icon': LineAwesomeIcons.check_circle, 'label': 'Restore User', 'color': const Color(0xFF34D399)});
    }
    if (user.role != 'Admin') {
      actions.add({'icon': LineAwesomeIcons.trash_alt_solid, 'label': 'Delete User', 'color': const Color(0xFFEF4444)});
    }
    return actions;
  }

  void _showConfirmSnackbar(
      BuildContext ctx, bool isDark, String action, String name) {
    ScaffoldMessenger.of(ctx).clearSnackBars();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Text(
          '$action applied to $name',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showInviteDialog(
    BuildContext ctx,
    bool isDark,
    Color primaryText,
    Color surfaceColor,
    Color borderColor,
    Color secondaryText,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Invite User',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text('Send an invitation to join Comfi',
                style: TextStyle(color: secondaryText, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _InviteField(
                label: 'Full Name',
                hint: 'e.g. Ama Owusu',
                icon: LineAwesomeIcons.user_solid,
                isDark: isDark,
                primaryText: primaryText,
                borderColor: borderColor,
              ),
              const SizedBox(height: 12),
              _InviteField(
                label: 'Email Address',
                hint: 'e.g. ama@gmail.com',
                icon: LineAwesomeIcons.envelope,
                isDark: isDark,
                primaryText: primaryText,
                borderColor: borderColor,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              Text('Role',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Buyer', 'Seller', 'Admin'].map((r) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: r == 'Buyer'
                            ? const Color(0xFF8B5CF6).withOpacity(0.12)
                            : isDark
                                ? const Color(0xFF1F2937)
                                : const Color(0xFFEEF1FB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: r == 'Buyer'
                              ? const Color(0xFF8B5CF6).withOpacity(0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(r,
                        style: TextStyle(
                          color: r == 'Buyer'
                              ? const Color(0xFF8B5CF6)
                              : primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showConfirmSnackbar(
                        ctx, isDark, 'Invitation sent', '');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Send Invitation',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortSheet(
    BuildContext ctx,
    bool isDark,
    Color primaryText,
    Color surfaceColor,
    Color borderColor,
  ) {
    final options = ['Name (A–Z)', 'Name (Z–A)', 'Most Orders', 'Highest Spend', 'Newest First'];
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Sort Users',
              style: TextStyle(
                color: primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((o) => GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFEEF1FB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(o,
                        style: TextStyle(
                          color: primaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: primaryText.withOpacity(0.3), size: 18),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;
  final Color cardBg;
  final Color primaryText;
  final Color secondaryText;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
    required this.cardBg,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(label,
              style: TextStyle(
                color: secondaryText,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final bool isDark;
  final Color borderColor;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : borderColor,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Center(
          child: Text(label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Avatar Widget ─────────────────────────────────────────────────────────────
class _AvatarWidget extends StatelessWidget {
  final _UserModel user;
  final double size;

  const _AvatarWidget({required this.user, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [user.avatarColor, user.avatarColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: user.avatarColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(user.initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.3,
          ),
        ),
      ),
    );
  }
}

// ── User Card ─────────────────────────────────────────────────────────────────
class _UserCard extends StatelessWidget {
  final _UserModel user;
  final bool isExpanded;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;
  final void Function(String) onAction;

  const _UserCard({
    required this.user,
    required this.isExpanded,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
    required this.onAction,
  });

  Color get _statusColor {
    switch (user.status) {
      case 'Active':    return const Color(0xFF34D399);
      case 'Inactive':  return const Color(0xFF94A3B8);
      case 'Suspended': return const Color(0xFFEF4444);
      default:          return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded
                ? const Color(0xFF8B5CF6).withOpacity(0.4)
                : borderColor,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
        ),
        child: Column(
          children: [
            // ── Main Row ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _AvatarWidget(user: user, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(user.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Role badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: user.roleColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(user.role,
                                style: TextStyle(
                                  color: user.roleColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(user.email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // Status dot
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                color: _statusColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _statusColor.withOpacity(0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(user.status,
                              style: TextStyle(
                                color: _statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('·', style: TextStyle(color: secondaryText)),
                            const SizedBox(width: 6),
                            Text(user.id,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand arrow
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: secondaryText, size: 22),
                  ),
                ],
              ),
            ),

            // ── Expanded Details ───────────────────────────────────
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _ExpandedDetails(
                user: user,
                isDark: isDark,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onAction: onAction,
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Expanded Details ──────────────────────────────────────────────────────────
class _ExpandedDetails extends StatelessWidget {
  final _UserModel user;
  final bool isDark;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;
  final void Function(String) onAction;

  const _ExpandedDetails({
    required this.user,
    required this.isDark,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);

    return Column(
      children: [
        Divider(height: 1, thickness: 1, color: borderColor),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
          child: Column(
            children: [
              // ── Mini stats ────────────────────────────────────────
              Row(
                children: [
                  _MiniStat(
                    label: 'Orders',
                    value: '${user.orders}',
                    icon: LineAwesomeIcons.box_solid,
                    color: const Color(0xFF8B5CF6),
                    cardBg: cardBg,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'Spent',
                    value: 'GHS ${user.totalSpent.toStringAsFixed(0)}',
                    icon: LineAwesomeIcons.wallet_solid,
                    color: const Color(0xFF34D399),
                    cardBg: cardBg,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'Since',
                    value: user.joined,
                    icon: LineAwesomeIcons.calendar,
                    color: const Color(0xFF0284C7),
                    cardBg: cardBg,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ── Action buttons ────────────────────────────────────
              Row(
                children: [
                  _ActionBtn(
                    label: 'Edit',
                    icon: LineAwesomeIcons.pencil_alt_solid,
                    color: const Color(0xFF8B5CF6),
                    onTap: () => onAction('Edit'),
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    label: 'Email',
                    icon: LineAwesomeIcons.envelope,
                    color: const Color(0xFF0284C7),
                    onTap: () => onAction('Email'),
                  ),
                  const SizedBox(width: 8),
                  _ActionBtn(
                    label: 'More',
                    icon: Icons.more_horiz_rounded,
                    color: const Color(0xFF64748B),
                    onTap: () => onAction('More'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Mini Stat ─────────────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color cardBg;
  final Color primaryText;
  final Color secondaryText;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.cardBg,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 6),
            Text(value,
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            Text(label,
              style: TextStyle(color: secondaryText, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 5),
              Text(label,
                style: TextStyle(
                  color: color,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Invite Field ──────────────────────────────────────────────────────────────
class _InviteField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isDark;
  final Color primaryText;
  final Color borderColor;
  final TextInputType keyboardType;

  const _InviteField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    required this.primaryText,
    required this.borderColor,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(color: primaryText, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF8B5CF6)),
        labelStyle: const TextStyle(
          color: Color(0xFF8B5CF6),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: primaryText.withOpacity(0.3),
          fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 14),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Color primaryText;
  final Color secondaryText;

  const _EmptyState({
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_search_rounded,
                color: Color(0xFF8B5CF6), size: 32),
          ),
          const SizedBox(height: 16),
          Text('No users found',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text('Try adjusting your search or filters',
            style: TextStyle(color: secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}