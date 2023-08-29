    /**
    * Return Authorization service provider instance.
    *
    * @param \Psr\Http\Message\ServerRequestInterface $request Request
    * @return \Authentication\AuthorizationServiceInterface
    */
    public function getAuthorizationService(ServerRequestInterface $request): AuthorizationServiceInterface
    {
        $resolver = new OrmResolver();
        return new AuthorizationService($resolver);
    }
