/**
 * Censorship
 *
 * Create a SQL function to censure a text by replacing obscene words with '@!#?@!'.
 * Example: 'Are you shitting me?' -> 'Are you @!#?@!ting me?'
 CREATE OR REPLACE FUNCTION CENSURE(m_text TEXT)
     RETURNS TEXT
     LANGUAGE plpgsql
 AS
 $$
 DECLARE
     m_elem TEXT;
     m_result TEXT;
     m_obscene_words TEXT[];
 BEGIN
     m_result = m_text;
     SELECT ARRAY_AGG(word) INTO m_obscene_words FROM obscene_word;
     
     FOREACH m_elem IN ARRAY m_obscene_words LOOP
         m_result = REGEXP_REPLACE( m_result, m_elem, '@!#?@!', 'ig');
     END LOOP;
     
     RETURN m_result;
 END;
 $$;
 */


/**
 * Validate blog insertion
 *
 * Create a trigger to validate and censure blog posts before insertion.
CREATE OR REPLACE FUNCTION CENSURE_NEW_BLOG_POST()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$

BEGIN
    NEW.title := CENSURE(NEW.title);
    NEW.body := CENSURE(NEW.body);
    
    RETURN NEW;
END;
$$;
 
CREATE TRIGGER validate_blog_insertion
    BEFORE INSERT
    ON blog
    FOR EACH ROW
    EXECUTE PROCEDURE CENSURE_NEW_BLOG_POST();
    
    
 */


/**
 * Testing
 *
 * Create a procedure to generate data (blog posts) for testing purposes.
 */
