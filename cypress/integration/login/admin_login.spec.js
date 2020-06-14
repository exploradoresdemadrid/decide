/// <reference types="cypress" />

context('Admin login', () => {
  before(() => {
    cy.clearCookies()
  })
  beforeEach(() => {
    cy.visit('http://localhost:3000/users/sign_in')
  })

  it('use valid password', () => {
    cy.loginAsAdmin()
    cy.get('.alert.alert-info').should('contain', 'Sesión iniciada.')
  })

  it('use invalid password', () => {
    cy.login('admin@example.com', 'invalidpass')
    cy.get('.alert.alert-danger').should('contain', 'Email o contraseña inválidos.')
  })

  it('logout', () => {
    cy.loginAsAdmin()
    cy.logout()
  })
})
