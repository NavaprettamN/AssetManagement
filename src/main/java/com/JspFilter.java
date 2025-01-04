package com;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class JspFilter implements Filter {
    private static final long serialVersionUID = 1L;

    public JspFilter() {
        super();
    }

    public void destroy() {

    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        if (requestURI.endsWith(".jsp") && !isRequestFromServlet(httpRequest)) {
            
            ((HttpServletResponse) response).sendError(HttpServletResponse.SC_FORBIDDEN, "Direct access to JSPs is not allowed.");
            return; 
        }
        chain.doFilter(request, response);
    }

    private boolean isRequestFromServlet(HttpServletRequest request) {
        return request.getAttribute("servlet.forwarded") != null;
    }

    public void init(FilterConfig fConfig) throws ServletException {

    }
}
