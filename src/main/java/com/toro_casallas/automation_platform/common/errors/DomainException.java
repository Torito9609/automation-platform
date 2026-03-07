package com.toro_casallas.automation_platform.common.errors;

public class DomainException extends RuntimeException {
    public DomainException(String message) {
        super(message);
    }

    public DomainException(String mesage, Throwable cause) { super(mesage, cause); }
}
