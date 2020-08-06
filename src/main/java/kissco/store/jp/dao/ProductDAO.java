package kissco.store.jp.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import kissco.store.jp.model.CategoryVO;
import kissco.store.jp.model.ProductVO;

@Repository
public class ProductDAO {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}

	// 상품 입력
	public boolean productUpload(ProductVO product) {
		String sql = "insert into product ( user_no, category, lat, lng, title, price, content, date, photopath,sumnail) "
				+ "values (?, ?, ?, ?, ?, ?, ?, now(), ?,?)";

		return (jdbcTemplate.update(sql, product.getUser_no(), product.getCategory(), product.getLat(),
				product.getLng(), product.getTitle(), product.getPrice(), product.getContent(), product.getPhotopath(),
				product.getSumnail()) == 1);

	}

	// 상품 삭제
	public boolean productDelete(int product_no) {

		String sql = "delete from product " + "where product_no = ? ";
		return (jdbcTemplate.update(sql, product_no) == 1);

	}

	// 상품 수정
	public boolean productUpdate(ProductVO product) {
		String sql = "update product "
				+ " set user_no=?, category=?, lat=?, lng=?, title=?, price=?, content=?, date=now(),photopath=?,sumnail=?"
				+ " where product_no=?";
		return (jdbcTemplate.update(sql, product.getUser_no(), product.getCategory(), product.getLat(),
				product.getLng(), product.getTitle(), product.getPrice(), product.getContent(), product.getPhotopath(),
				product.getSumnail(), product.getProduct_no()) == 1);

	}

	// 상품 상세
	public ProductVO productInfo(int product_no) {
		String sql = " SELECT product_no, user_no, category, lat, lng, title, price, content, date,photopath,sumnail"
				+ " from product WHERE product_no=?";
		return jdbcTemplate.queryForObject(sql, new RowMapper<ProductVO>() {

			@Override
			public ProductVO mapRow(ResultSet rs, int rowNum) throws SQLException {
				ProductVO product = new ProductVO();

				product.setProduct_no(rs.getInt("product_no"));
				product.setUser_no(rs.getInt("user_no"));
				product.setCategory(rs.getInt("category"));
				product.setLat(rs.getDouble("lat"));
				product.setLng(rs.getDouble("lng"));
				product.setTitle(rs.getString("title"));
				product.setPrice(rs.getInt("price"));
				product.setContent(rs.getString("content"));
				product.setDate(rs.getTimestamp("date"));
				product.setPhotopath(rs.getString("photopath"));
				product.setSumnail(rs.getString("sumnail"));

				return product;
			}

		}, product_no);

	}

	// 상품 리스트, limit,offset값 안 넣음!!
	public List<ProductVO> productList() {

		String sql = "SELECT SQL_CALC_FOUND_ROWS A.* FROM ( "
				+ " SELECT product_no, user_no, category, lat, lng, title, price, content, date,photopath"
				+ " FROM product" + " ORDER BY product_no DESC " + ") A LIMIT ? OFFSET ?; ";

		return jdbcTemplate.query(sql, new RowMapper<ProductVO>() {

			@Override
			public ProductVO mapRow(ResultSet rs, int rowNum) throws SQLException {

				ProductVO product = new ProductVO();
				product.setProduct_no(rs.getInt("product_no"));
				product.setUser_no(rs.getInt("user_no"));
				product.setCategory(rs.getInt("category"));
				product.setLat(rs.getDouble("lat"));
				product.setLng(rs.getDouble("lng"));
				product.setTitle(rs.getString("title"));
				product.setPrice(rs.getInt("price"));
				product.setContent(rs.getString("content"));
				product.setDate(rs.getTimestamp("date"));
				product.setPhotopath(rs.getString("photopath"));
				product.setSumnail(rs.getString("sumnail"));

				return product;
			}

		});

	}

	// category
	public String category(int category_no) {
		System.out.println("product_no" + category_no);
		String sql = " SELECT category_title from category where category_no=?";

		return jdbcTemplate.queryForObject(sql, String.class, category_no);
	}

	// 해당 user 상품 목록
	public List<ProductVO> productList(int user_no) {
		String sql = "SELECT SQL_CALC_FOUND_ROWS A.* FROM ( SELECT product_no, user_no, category, lat, lng, title, price, content, date,photopath, sumnail "
				+ " FROM product where user_no = ? ORDER BY product_no DESC )A;";

		return jdbcTemplate.query(sql, new RowMapper<ProductVO>() {

			@Override
			public ProductVO mapRow(ResultSet rs, int rowNum) throws SQLException {

				ProductVO product = new ProductVO();
				product.setProduct_no(rs.getInt("product_no"));
				product.setUser_no(rs.getInt("user_no"));
				product.setCategory(rs.getInt("category"));
				product.setLat(rs.getDouble("lat"));
				product.setLng(rs.getDouble("lng"));
				product.setTitle(rs.getString("title"));
				product.setPrice(rs.getInt("price"));
				product.setContent(rs.getString("content"));
				product.setDate(rs.getTimestamp("date"));
				product.setPhotopath(rs.getString("photopath"));
				product.setSumnail(rs.getString("sumnail"));

				return product;
			}

		}, user_no);

	}

	public List<ProductVO> productListALL(String word, int min, int max, String p_sort, int page) {
		String searchWord = "%" + word + "%";
		String sql = " SELECT SQL_CALC_FOUND_ROWS A.* FROM ( " + " SELECT p.product_no, p.user_no, p.category, "
				+ " p.lat, p.lng, p.title, p.price, p.content, p.date, p.sumnail "
				+ " FROM product p WHERE p.title LIKE ?  AND p.price BETWEEN ? AND ? ORDER BY " + p_sort
				+ " ) A LIMIT 9 OFFSET ? ";
		return jdbcTemplate.query(sql, new RowMapper<ProductVO>() {

			@Override
			public ProductVO mapRow(ResultSet rs, int rowNum) throws SQLException {
				ProductVO product = new ProductVO();
				product.setProduct_no(rs.getInt("product_no"));
				product.setUser_no(rs.getInt("user_no"));
				product.setCategory(rs.getInt("category"));
				product.setLat(rs.getDouble("lat"));
				product.setLng(rs.getDouble("lng"));
				product.setTitle(rs.getString("title"));
				product.setPrice(rs.getInt("price"));
				product.setContent(rs.getString("content"));
				product.setDate(rs.getTimestamp("date"));
				product.setSumnail(rs.getString("sumnail"));
				return product;
			}

		}, searchWord, min, max, page);
	}

	public List<ProductVO> productListByCategory(int category_no, String word, int min, int max, String p_sort,
			int page) {
		String searchWord = "%" + word + "%";
		String sql = " SELECT SQL_CALC_FOUND_ROWS A.* FROM ( " + " SELECT p.product_no, p.user_no, p.category, "
				+ " p.lat, p.lng, p.title, p.price, p.content, p.date, p.sumnail "
				+ " FROM product p WHERE p.category = ? AND p.title LIKE ? " + "  AND p.price BETWEEN ? AND ? ORDER BY "
				+ p_sort + " ) A LIMIT 9 OFFSET ? ";
		return jdbcTemplate.query(sql, new RowMapper<ProductVO>() {

			@Override
			public ProductVO mapRow(ResultSet rs, int rowNum) throws SQLException {
				ProductVO product = new ProductVO();
				product.setProduct_no(rs.getInt("product_no"));
				product.setUser_no(rs.getInt("user_no"));
				product.setCategory(rs.getInt("category"));
				product.setLat(rs.getDouble("lat"));
				product.setLng(rs.getDouble("lng"));
				product.setTitle(rs.getString("title"));
				product.setPrice(rs.getInt("price"));
				product.setContent(rs.getString("content"));
				product.setDate(rs.getTimestamp("date"));
				product.setSumnail(rs.getString("sumnail"));
				return product;
			}

		}, category_no, searchWord, min, max, page);
	}

	public int productTotalCnt(String word) {
		String searchWord = "%" + word + "%";
		String sql = "SELECT COUNT(*) FROM product p WHERE p.title LIKE ? ";
		return jdbcTemplate.queryForObject(sql, Integer.class, searchWord);
	}

	public int productTotalCntByCategory(int category_no, String word) {
		String searchWord = "%" + word + "%";
		String sql = "SELECT COUNT(*) FROM product p WHERE category = ? AND p.title LIKE ? ";

		return jdbcTemplate.queryForObject(sql, Integer.class, category_no, searchWord);
	}

	public List<CategoryVO> listByCategory() {
		String sql = "select * from category";
		return jdbcTemplate.query(sql, new RowMapper<CategoryVO>() {

			@Override
			public CategoryVO mapRow(ResultSet rs, int rowNum) throws SQLException {
				CategoryVO category = new CategoryVO();
				category.setCategory_no(rs.getInt("category_no"));
				category.setCategory_title(rs.getString("category_title"));
				return category;
			}

		});
	}

	public int[] min_maxALL() {
		String sql = "SELECT MIN(price) min, MAX(price) max FROM product ";
		return jdbcTemplate.queryForObject(sql, new RowMapper<int[]>() {

			@Override
			public int[] mapRow(ResultSet rs, int rowNum) throws SQLException {
				int[] min_maxPrice = new int[2];
				min_maxPrice[0] = rs.getInt("min");
				min_maxPrice[1] = rs.getInt("max");

				return min_maxPrice;
			}
		});
	}

	public int[] min_maxByCategory(int category_no) {
		String sql = "SELECT MIN(price) min, MAX(price) max FROM product WHERE category = ? ";
		return jdbcTemplate.queryForObject(sql, new RowMapper<int[]>() {

			@Override
			public int[] mapRow(ResultSet rs, int rowNum) throws SQLException {
				int[] min_maxPrice = new int[2];
				min_maxPrice[0] = rs.getInt("min");
				min_maxPrice[1] = rs.getInt("max");

				return min_maxPrice;
			}
		}, category_no);
	}
}
