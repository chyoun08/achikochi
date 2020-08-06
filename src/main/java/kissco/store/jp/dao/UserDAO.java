package kissco.store.jp.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import kissco.store.jp.model.ProductVO;
import kissco.store.jp.model.UserVO;
import kissco.store.jp.model.WishlistVO;

@Repository
public class UserDAO {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public boolean registUser(UserVO user) {

		String sql = "insert into users ( authority, user_id, user_pw, nickname, mail, lat, lng, introduce, user_key, enabled) "
				+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		return (jdbcTemplate.update(sql, user.getAuthority(), user.getUser_id(), user.getUser_pw(), user.getNickname(),
				user.getMail(), user.getLat(), user.getLng(), user.getIntroduce(), user.getUser_key(),
				user.getEnabled()) == 1);
	}

	// 회원정보 업데이트
	public boolean updateUser(UserVO user) {
		String sql = "update users set user_pw=?, nickname=?, lat=?, lng=?, introduce=? where user_no=?";

		return (jdbcTemplate.update(sql, user.getUser_pw(), user.getNickname(), user.getLat(), user.getLng(),
				user.getIntroduce(), user.getUser_no()) == 1);
	}

	// 회원삭제
	public boolean deleteUser(int user_no) {
		String sql = "delete from users where user_no=?";
		return (jdbcTemplate.update(sql, user_no) == 1);
	}

	// Id로 가져오기
	public UserVO getUserById(String user_id) {
		String sql = "SELECT * FROM users WHERE user_id = ? ";

		return jdbcTemplate.queryForObject(sql, new Object[] { user_id }, new RowMapper<UserVO>() {
			@Override
			public UserVO mapRow(ResultSet rs, int count) throws SQLException {
				UserVO user = new UserVO();
				user.setUser_no(rs.getInt("user_no"));
				user.setUser_id(rs.getString("user_id"));
				user.setUser_pw(rs.getString("user_pw"));
				user.setNickname(rs.getString("nickname"));
				user.setAuthority(rs.getString("authority"));
				user.setIntroduce(rs.getString("introduce"));
				user.setLat(rs.getDouble("lat"));
				user.setLng(rs.getDouble("lng"));
				user.setMail(rs.getString("mail"));
				return user;
			}
		});
	}

	// 기본키로 가져오기
	public UserVO getUserByNo(int user_no) {
		String sql = "select * from users where user_no = ? ";

		return jdbcTemplate.queryForObject(sql, new Object[] { user_no }, new RowMapper<UserVO>() {
			@Override
			public UserVO mapRow(ResultSet rs, int count) throws SQLException {
				UserVO user = new UserVO();
				user.setUser_no(rs.getInt("user_no"));
				user.setUser_id(rs.getString("user_id"));
				user.setUser_pw(rs.getString("user_pw"));
				user.setNickname(rs.getString("nickname"));
				user.setAuthority(rs.getString("authority"));
				user.setIntroduce(rs.getString("introduce"));
				user.setLat(rs.getDouble("lat"));
				user.setLng(rs.getDouble("lng"));
				user.setMail(rs.getString("mail"));
				return user;
			}
		});
	}

	// 기본키로 가져오기
	public int alterUserPwByMail(String user_pw, String mail) {
		String sql = "update users set user_pw = ? where mail = ?";
		return jdbcTemplate.update(sql, user_pw, mail);
	}

	// user_key를 난수로 생성한다.
	public int getKey(String user_id, String user_key) {
		String sql = "update users set user_key = ? where user_id = ?";
		return jdbcTemplate.update(sql, user_key, user_id);
	}

	// 난수화된 user_key를 Y값으로 변경한다.
	public boolean alter_userKey(String user_id, String user_key) {
		String sql = "update users set user_key = 'Y', enabled = '1' where user_id = ? and user_key = ?";
		return (jdbcTemplate.update(sql, user_id, user_key) == 1);
	}

	public List<ProductVO> getMySellList(String user_id ) {
		String sql = " select p.product_no, u.user_no, p.title, p.price, p.content, p.sumnail "
				+ " from product p, users u "
				+ " where user_id = ? and p.user_no = u.user_no ";
		return jdbcTemplate.query(sql, new RowMapper<ProductVO>() {

			@Override
			public ProductVO mapRow(ResultSet rs, int rowNum) throws SQLException {
				ProductVO product = new ProductVO();
				product.setProduct_no(rs.getInt("product_no"));
				product.setUser_no(rs.getInt("user_no"));
				product.setTitle(rs.getString("title"));
				product.setPrice(rs.getInt("price"));
				product.setContent(rs.getString("content"));
				product.setSumnail(rs.getString("sumnail"));
				return product;
			}

		}, user_id);
	}
	
	public List<WishlistVO> getWishList(int user_no) {

		String sql = "select w.wishlist_no, w.user_no, u.nickname, "
				+ " w.product_no, p.price, p.title, p.content, p.date, p.sumnail "
				+ " from wishlist w, product p, users u where w.user_no = ? "
				+ " and p.product_no = w.product_no and u.user_no = w.user_no order by p.date desc ";

		return jdbcTemplate.query(sql, new Object[] { user_no }, new RowMapper<WishlistVO>() {

			@Override
			public WishlistVO mapRow(ResultSet rs, int rowNum) throws SQLException {

				WishlistVO vo = new WishlistVO();

				vo.setWishlist_no(rs.getInt("wishlist_no"));
				vo.setUser_no(rs.getInt("user_no"));
				vo.setNickname(rs.getString("nickname"));
				vo.setProduct_no(rs.getInt("product_no"));
				vo.setContent(rs.getString("content"));
				vo.setPrice(rs.getInt("price"));
				vo.setTitle(rs.getString("title"));
				vo.setDate(rs.getTimestamp("date"));
				vo.setSumnail(rs.getString("sumnail"));
				return vo;
			}
		});
	}

	public boolean insertWishlist(int user_no, int product_no) {
		
		String sql = "insert into wishlist ( user_no, product_no ) select ?, ? "
				+ " from wishlist "
				+ " where not exists (select * from wishlist where user_no = ? and product_no = ?) LIMIT 1";

		return (jdbcTemplate.update(sql, user_no, product_no, user_no, product_no) == 1);
	}
	
	public boolean deleteWishlist(int product_no, int user_no) {
		String sql = "delete from wishlist where product_no=? and user_no=?";
		return (jdbcTemplate.update(sql, product_no, user_no) == 1);
	}

	public boolean deleteWishlistALL(int user_no) {
		String sql = "delete from wishlist where user_no=?";
		return (jdbcTemplate.update(sql, user_no) == 1);
	}

}
