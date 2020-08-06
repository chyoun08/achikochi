package kissco.store.jp.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import kissco.store.jp.model.CommentVO;

@Repository
public class CommentDAO {
	
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	//comment 리스트
	public List<CommentVO> commentList(int product_no) {
		
		String sql = "SELECT SQL_CALC_FOUND_ROWS A.* FROM ( SELECT c.comment_no, c.product_no, c.user_no, c.content, c.date, u.nickname FROM comment c, users u " + 
				"where u.user_no= c.user_no and c.product_no = ?  ORDER BY comment_no )A;";
				  
				  return jdbcTemplate.query(sql, new RowMapper<CommentVO>() {
				  
				  @Override public CommentVO mapRow(ResultSet rs, int rowNum) throws SQLException
				  { 

					  	CommentVO comment = new CommentVO();
					  	comment.setComment_no(rs.getInt("comment_no"));
					  	comment.setProduct_no(rs.getInt("product_no"));
					  	comment.setUser_no(rs.getInt("user_no"));
					  	comment.setContent(rs.getString("content"));
					  	Calendar cal = new GregorianCalendar();
			            comment.setDate(rs.getTimestamp("date",cal));
			            comment.setNickname(rs.getString("nickname"));
					  	
					  	

						return comment;
				  }
				  
				  },product_no);
		
		
	}
	

	//Comment 업로드
	public boolean uploadComment(CommentVO comment) {
		String sql = "insert into comment ( product_no, user_no, content, date) "
				+ "values (?, ?, ?, now())";

		return (jdbcTemplate.update(sql, comment.getProduct_no(),comment.getUser_no(),comment.getContent())==1);
	}
	
	//Comment 삭제
	public boolean deleteComment(int comment_no) {
		String sql = "delete from comment where comment_no = ? ";
		return (jdbcTemplate.update(sql, comment_no)==1);
	}
	
	//comment 수정
	public boolean uploadComment(int comment_no, String content) {
		String sql = "update comment set content=?, date=now() where comment_no=?";
		
		return (jdbcTemplate.update(sql, content, comment_no)==1);
	}


}
